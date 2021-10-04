import React, { useState, useEffect, useRef, Fragment, useContext } from 'react'
import GetInterviewRow from './GetInterviewRow'
import Button from 'react-bootstrap/Button'
import AtMentionInput from '../AtMentionInput/AtMentionInput'
import styles from './styles/ScheduleInterviewDetails.module.scss'
import { nanoid } from 'nanoid'
import Form from 'react-bootstrap/Form'
import EmailClient from '../EmailClient/EmailClient'
import feather from 'feather-icons'
import XButton from '../XButton/XButton'
import { StoreDispatchContext } from '../../../stores/JDPStore'
import { makeRequest } from '../RequestAssist/RequestAssist'
import RenderEditTooltip from '../ScheduleInterviwes/ScheduledTable/RenderEditTooltip'
import Dropdown from 'react-bootstrap/Dropdown'

function ScheduleInterviewDetails({hideModal, submitText, user ,candidate, interview, url, method, jobs, openModal=(false), dateselected , scheduleInterview, fullJob}) {
    const [description, setDescription] = useState()
    const [interviewers, setInterviewers] = useState([])
    const [showAtMentionInput, setShowAtMentionInput] = useState(false)
    const [interviews, setInterviews] = useState([
        { id: nanoid(), date: null, time: null, stage: null, timeZone: null },
    ])
    const [checkedEmail, setCheckedEmail] = useState(false)
    const [checkedCalender, setCheckedCalender] = useState(false)
    const atMentionInputRef = useRef(null)
    const [selectedDate, setSelectedDate] = useState(dateselected ? dateselected : new Date())
    const [selectedTimes, setSelectedTimes] = useState(candidate.interview_time ? JSON.parse(candidate.interview_time) : [])
    const [selectedStages, setSelectedStages] = useState(candidate.interview_type ? [{label:candidate.interview_type,id:candidate.interview_type}] : [])
    const [selectedJobs, setSelectedJobs] = useState(candidate.job_title ? {id:candidate.job_id,name:candidate.job_title} : [])
    const [show, setShow] = useState(null)
    const [isEdit, setIsEdit] = useState(true)
    const [indexValue, setIndexValue] = useState()
    const [jobError, setJobError] = useState(false)
    const [stageError, setStageError] = useState(false)
    const [dateError, setDateError] = useState(false)
    const [timeError, setTimeError] = useState(false)
    const [responceMsg, setResponceMsg] = useState('')
    const [amError , setAmError] = useState(false)
    const [interviewError, setInterviewerError] = useState(false)
    var error = false
    const [haveError , setHaveError] = useState(0)

    useEffect(() => {
        if (showAtMentionInput) {
            atMentionInputRef.current.focus()
        }
    }, [showAtMentionInput])

    useEffect(() => {
        feather.replace()
    }, [interviews])

    useEffect(() => {
      if (fullJob) {
        setJobError(false)
      }
    })

    const formatTime = () => {
      return selectedTimes.map((time, index) => {
        return Object.assign(time, {stage: selectedStages[index]['id']})
      });
    }

    const handleDeleteInterviewer = (index) => {
        const intViwer = interviewers.filter((_, ind) => ind != index)
        setInterviewers([...intViwer])
    }
    /**
     * candidate is null if this component
     * evoked from candidate search or my jobs .
     */
    const getPersonId = () => {
      if(candidate != null ) {
        if (candidate.person_id != undefined ){
            return candidate.person_id
        } else
          {
           return candidate.id
          }
      }
      return interview.person_id
    }
    const prepare_payload = () => {
        let job_data = new Date(selectedDate)
      const formData = new FormData()
      let interview = {
        interview_date: selectedDate? job_data.toDateString() : '',
        description: description ? description : '',
        person_id: getPersonId(),
        interviewer_ids: interviewers.map((h) => (h.id)).join(','),
        job_id: selectedJobs?.id ? selectedJobs.id : fullJob.id,
        interview_type: selectedStages.map((item) => (item.id)),
        send_email: checkedEmail,
        send_invite_like: checkedCalender,
        interview_time: JSON.stringify(formatTime()),
        interviewers: JSON.stringify(interviewers)
      }
     
      formData.append('interview_schedule[interview_date]', interview.interview_date)
      formData.append('interview_schedule[description]', interview.description)
      formData.append('interview_schedule[person_id]', interview.person_id)
      formData.append('interview_schedule[interviewer_ids]', interview.interviewer_ids)
      formData.append('interview_schedule[job_id]', interview.job_id)
      formData.append('interview_schedule[interview_type]', interview.interview_type)
      formData.append('interview_schedule[send_email]', interview.send_email)
      formData.append('interview_schedule[send_invite_link]', interview.send_invite_like)
      formData.append('interview_schedule[interview_time]', interview.interview_time)
      formData.append('interview_schedule[interviewers]', interview.interviewers)

      return formData
    }
    
    const handleSubmit = () => {
        let errorList = []
        selectedTimes.map((timezone,index) => {
          if(timezone.minute === ""){
            timezone.minute = "00"
          }
          if((timezone.hour === "00") || (timezone.hour === "")) {
            setTimeError(index)
            timezone.timezoneerr = "please select time"
            errorList.push(true)
          }
          else if(timezone.timeZone === 'Time-zone') {
            setTimeError(index)
            timezone.timezoneerr = "please select timezone"
            errorList.push(true)
          }
          else {
            if((timezone.isAM === "PM" &&  timezone.hour > "05" && timezone.hour < "12" ) || (timezone.isAM === "AM" && timezone.hour < "08") || (timezone.isAM === "AM" && timezone.hour === "12"))
             {
                setTimeError(index)
                timezone.timezoneerr = "You are scheduling interviews outside normal"
                errorList.push(true)
            }
            else if( timezone.minute > "00" && timezone.hour === "05"){
                setTimeError(index)
                timezone.timezoneerr = "You are scheduling interviews outside normal"
                errorList.push(true)
            }
            else {
                errorList.splice(index, 1);
                timezone.timezoneerr = null
                setTimeError(false)
            }                
          }
          setHaveError(1)
          return timezone
        }) 
        setSelectedTimes(selectedTimes)
        if (selectedJobs?.name === undefined) { setJobError(true) } else { setJobError(false) }
        if (selectedStages.length === 0) { setStageError(true) } else { setStageError(false) }
        if (selectedDate === undefined) { setDateError(true) } else { setDateError(false) }
        
        if ((!(selectedJobs?.name === undefined) || fullJob?.name !== undefined  ) && !(selectedStages.length === 0) && !(selectedDate === undefined) && (errorList.length === 0)){           
            const payload = prepare_payload()
            makeRequest(url, method, payload)
            .then(function(res){
                if(res&&res.data.msg === "Interview Scheduled Successfully And Mail Has Been Send")
                {
                    scheduleInterview(res)   
                    hideModal(false)
                }
                else if(res&&res.data.msg === "Interview Reschedule Successfully And Mail Has Been Send"){
                    setResponceMsg(res.data.msg)
                    setShow(indexValue)
                    setIsEdit(true)
                    hideModal(false)
                    window.location.reload()
                }
                else{
                    setResponceMsg(res.data.msg)
                    setShow(indexValue)
                    setIsEdit(true)
                }
               
            });
        }
    }
    
    const handleIndexValue = (index) => {
        setIndexValue(index)
    }
    const handleJobFullName = (name) => {
      return name.length < 42 ? name : name.slice(0,39) + '...'
    }
    return (
        <div style={{ width: '100%' }}>
            <>
                <div>
                    <Dropdown>
                        <Dropdown.Toggle style={{width: '20rem', marginBottom: '7px'}} title={selectedJobs?.name}>
                            {selectedJobs.name ? handleJobFullName(selectedJobs?.name) : fullJob?.name ? handleJobFullName(fullJob?.name) : 'Select Job'}
                        </Dropdown.Toggle>
                        <Dropdown.Menu>
                            {jobs && jobs.length > 0 ? jobs.map((job) => (
                                <Dropdown.Item
                                    key={job.id}
                                    onSelect={(e) => {
                                        setSelectedJobs(job)
                                        setJobError(false)
                                    }}
                                    value={job.id}
                                    eventKey={job.id}
                                >
                                    {job.name}
                                </Dropdown.Item>
                            )) :
                                fullJob?.name ? 
                                  <Dropdown.Item>
                                    {fullJob?.name}
                                  </Dropdown.Item> :
                                  <Dropdown.Item>
                                      No Job Available For This Organization
                                  </Dropdown.Item>
                                
                          }
                        </Dropdown.Menu>
                    </Dropdown>
                    {jobError && <p style={{color: "red"}}>Please select job</p>}
                </div>
                <div className={styles.interviewsSection}>
                    {interviews.map((interviewData, index) => (
                        <Fragment key={index} onClick={() => {handleIndexValue(index)}}>
                            <GetInterviewRow
                                interviews={interviews}
                                setInterviews={setInterviews}
                                interviewData={interviewData}
                                interviewIndex={index}
                                setSelectedDate={setSelectedDate}
                                selectedDate={selectedDate}
                                selectedTimes={selectedTimes}
                                selectedStages={selectedStages}
                                setSelectedTimes={setSelectedTimes}
                                setSelectedStages={setSelectedStages}
                                candidate={candidate}
                                dateselected={dateselected}
                                stageError={stageError}
                                dateError={dateError}
                                timeError={timeError}
                                setStageError={setStageError}
                                setTimeError={setTimeError}
                                amError={amError}
                                setAmError={setAmError}
                                setHaveError={setHaveError}
                                haveError={haveError}
                            />
                        </Fragment>
                    ))}
                </div>
                <div className={styles.selectorContainer}>
                    <div className={styles.emailCheackbox}>
                        <Form.Check
                            className={styles.Checkbox}
                            type="checkbox"
                            value="true"
                            name="email"
                            checked="checked"
                            onChange={() => setCheckedEmail(!checkedEmail)}
                            onClick={(event) => event.stopPropagation()}
                        />
                        <span className={styles.textCheckbox}>
                            Send email to candidate
                        </span>
                    </div>
                    <div className={styles.emailCheackbox}>
                        <Form.Check
                            className={styles.Checkbox}
                            type="checkbox"
                            value="true"
                            name="chalendar"
                            checked="checked"
                            onChange={() =>
                                setCheckedCalender(!checkedCalender)
                            }
                            onClick={(event) => event.stopPropagation()}
                        />
                        <span className={styles.textCheckbox}>
                            Send Google calendar invite to the candidate
                        </span>
                    </div>
                </div>
                <div className={styles.textareaContainer}>
                    <span className={styles.eventText}>EVENT DESCRIPTION:</span>
                    <Form.Control
                        className={styles.descriptionTextarea}
                        as="textarea"
                        value={description}
                        name="description"
                        rows="3"
                        onChange={(e) => {
                            setDescription(e.target.value)
                        }}
                        placeholder="This is a private description which will only be viewable to you and any other interviewers added"
                        onClick={(event) => event.stopPropagation()}
                    />
                </div>
                <div className={styles.emailSection}>
                  { submitText !== "Save Changes" &&
                      <EmailClient
                          emailClientId={'emailclientfor_' + 'scheduler'}
                          userId={user.id}
                          isEmailConfigured={true}
                          userEmail={user.email || ''}
                          showByDefault={true}
                          mailSentCallback={() => {}}
                          sendList={[candidate]}
                          embedded={true}
                      />
                  }
                </div>
                <div className={styles.rowFooter}>
                    <Button
                        className={styles.rowFooterBtn}
                        onClick={handleSubmit}
                    >
                        {submitText}
                    </Button>
                </div>
            </>
        </div>
    )
}

export default ScheduleInterviewDetails