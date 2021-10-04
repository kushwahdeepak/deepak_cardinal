import React, { useEffect, Fragment, useState, useRef  } from 'react'
import feather from 'feather-icons'
import { Button, OverlayTrigger, Row ,Col, Table, Modal, Alert} from 'react-bootstrap'
import styles from './styles/ScheduledTable.module.scss'
import './styles/ScheduledTable.scss'
import RenderDeleteTooltip from './RenderDeleteTooltip'
import ScheduleInterviewDetails from '../../ScheduleInterviewDetails/ScheduleInterviewDetails'
import { formatDate, formatStage, getStageFromTimeHash, interviewStageTime, getPrimaryInterviewer, getAdditionalInterviewer, getAllInterviewers } from '../../Utils'
import { makeRequest } from '../../../common/RequestAssist/RequestAssist'
import ProfileImage from '../../../../../assets/images/icons/profile.png'
import PhoneIcon from '../../../../../assets/images/phone-icon.png'
import EmailIcon from '../../../../../assets/images/email-icon.png'
import axios from 'axios'
import ScheduledFeedbackModal from './ScheduledFeedbackModal'
import './styles/scheduledTable.css'
import '../../ScheduleInterviewDetails/styles/RenderInterviewScheduleDetails.css'
import style from '../../../pages/EmployerDashboard/Table/styles/Table.module.scss'
import Util from '../../../../utils/util'

function SheduledTableBody({ interviews, user, jobs, myInterview}) {
  const ref = useRef();
  const [show, setShow] = useState(null)
  const [isEdit, setIsEdit] = useState(true)
  const [addFeedback, setAddFeedback] = useState(false)
  const [messageOpen, setMessageOpen] = useState(false)
  const [switchButton, setSwitchButton] = useState(true)
  const [indexValue, setIndexValue] = useState()
  const [showCancelModal, setShowCancelModal] = useState(null)
  const [indexData, setIndexData] = useState(1)
  const [interviewDetails ,setInterviewDetails] = useState({})
  const [feedbackValue, setFeedbackValue] = useState()
  const [message, setmessage] = useState(null)
  const [messageType, setmessageType] = useState("success")                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
  const [isMessage, setIsMessage] = useState(false)
  const [errormessageType, setErrormessageType] = useState("error")
  const [FeedbackError, setFeedbackError ] = useState(false)
  const [modal, setModal] = useState(true)
  const [deleteModal, setDeleteModal ] = useState(false)
  const [addModalFeedback, setAddModalFeedback] = useState(false)
  const [updateModalFeedback, setUpdateModalFeedback] = useState(false)
  const [isErrorMessage, setIsErrorMessage] = useState(false)
  const [openFeedbackMessage, setOpenFeedbackMessage] = useState('')
  const [data, setData] = useState([])
  const [feedbackId, setFeedbackId] = useState([])
  const [feedbackCancelModal, setFeedbackCancelModal] = useState(false)
  const [feedbackModal, setFeedbackModal] = useState(false)
  const [dataId, setDataId] = useState('')
  const [backgroundColor, setBackgroundColor] = useState({
    active: false, id: null, matchDate: null})
  const endpoint = `/interview_schedules/${interviewDetails.id}`
  useOnClickOutside(ref, () => setModal(false));
  useEffect(() => {
    feather.replace()
  })
  function formatDate(date) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) 
        month = '0' + month;
    if (day.length < 2) 
        day = '0' + day;

    return [year, month, day].join('-');
    }

  const handleSubmit = async() => {
    const url = `/interview_feedbacks`
    const CSRF_Token = document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute('content')

    const payload = JSON.stringify({
        feedback: feedbackValue,
        interview_schedule_id: interviewDetails.id
    })

    if (feedbackValue){
        setFeedbackError(false)
        try{
            const res = await axios.post(url, payload, {
                headers: {
                    'content-type': 'application/json',
                    'X-CSRF-Token': CSRF_Token,
                },
            })
            if (res?.data?.messageType == 'success') {
                  setIsMessage(true)
                  setmessageType("success")
                  setmessage("Feedback added successfully")
                  setTimeout(() => {
                  setIsMessage(false);
                  setFeedbackModal(true)
                  if(addModalFeedback == true){
                   setAddModalFeedback(false)
                   handleFeedbackList(dataId)
                  }
                  }, 1500);
                }
        } catch (error) {
                console.log(error)
        }
    }else{
        setFeedbackError(true)
    }
  }
  async function handleFeedbackList(id) {
    setTimeout(()=> {
      setModal(false)
      setFeedbackCancelModal(null)
      setFeedbackModal(true)
    }, 400)
    
    const url = `interview_feedbacks/feedbacks/${id}`
      await  axios
      .get(url)
      .then((res) => {
          setData(res.data)
      })
      .catch((err) => {
          console.log(err)
      })
  }
  const handleAddFeedback = () => {
    if (formatDate(new Date()) <= interviewDetails.interview_date){
        setIsErrorMessage(true)
        setErrormessageType("error")
        setmessage("For now you can not add feedback because interview is not held yet!")
        setTimeout(() => {
          setIsErrorMessage(false) ;
        }, 1000);
        setAddFeedback(false)
    }else{
    setIsErrorMessage(false)
    addFeedback? setAddFeedback(false) : setAddFeedback(true)
    }
  }

  const handleKeyPress = (e) => {
    if (e.which === 13 && e.key === 'Enter') {
        handleSubmit()
    }
  }

  const handleUpdateKeyPress = (e) => {
    if (e.which === 13 && e.key === 'Enter') {
        handleSubmitUpdate()
    }
  }
    const handleSubmitUpdate = async() => {
        const url = `interview_feedbacks/${feedbackId}`
        const CSRF_Token = document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute('content')

        const payload = JSON.stringify({
            feedback: feedbackValue
        })
        
        if (feedbackValue){
            setFeedbackError(false)
            try{
                const res = await axios.put(url, payload, {
                    headers: {
                        'content-type': 'application/json',
                        'X-CSRF-Token': CSRF_Token,
                    },
                })
                if (res?.data?.messageType == 'success') {
                                setIsMessage(true)
                                setmessageType("success")
                                setmessage("Feedback updated successfully")
                                setTimeout(() => {
                                setIsMessage(false) ;
                                setFeedbackModal(true)
                                if(updateModalFeedback){
                                  setUpdateModalFeedback(false)
                                  handleFeedbackList(dataId)
                                }
                              }, 1500);
                    }
            } catch (error) {
                    console.log(error)
                }
        }else{
            setFeedbackError(true)
        }
    }

  const handleIndexValue = (index, interview, date) => {
    setFeedbackError(false)
    setAddFeedback(false)
    setOpenFeedbackMessage(false)
    setIndexValue(index)
    setInterviewDetails(interview)
    setBackgroundColor({id: index, active: true, matchDate: date})
  }
  const handleMessageClick = () => {
    messageOpen? setMessageOpen(false) : setMessageOpen(true)
  }
  const handleModalClick = () => {
    setModal(false)
  }
  const handleModalFeedback = () => {
    if (formatDate(new Date()) <= interviewDetails.interview_date){
      setIsErrorMessage(true)
      setErrormessageType("danger")
      setmessage("For now you can not add feedback because interview is not held yet!")
      setTimeout(() => {
        setIsErrorMessage(false) ;
      }, 1500);
    }
    else{
      setFeedbackValue('')
      setAddModalFeedback(true)
    }
  }
  const handleUpdateModalFeedback = (data) =>{
    setUpdateModalFeedback(data)
  }
  const handleShowFeedback = () => {
     openFeedbackMessage? setOpenFeedbackMessage(false) : setOpenFeedbackMessage(true)
    }
  const handleCancel = (id) => {
    const url = `/interview_schedules/${id}/cancel`
    makeRequest(url, 'get', '', {})
    .then((res) => {
      setIndexData(3)
      window.location.reload();
    });
    }
  const handlefeedbackCancel = (id) => {
      const url = `/interview_feedbacks/${id}`
      makeRequest(url, 'DELETE', '', {})
      .then((res) => {
        setIndexData(3)
        setFeedbackCancelModal(false)
        handleFeedbackList(dataId)
      });
  }
  const showInterviewers = (interviewers) => {
    const propOwn = JSON.parse(interviewers);
    return(
      <>
        {interviewers? getPrimaryInterviewer(interviewers) : ''}
            {propOwn.length > 2 ?
            <div>{`and ${propOwn.length-1} others`}</div> :
            <div>{propOwn.length > 1? ', ' + getAdditionalInterviewer(interviewers): ''}</div>
        }
      </>
    )
  }
  const handleFullName = (firstName, lastName) => {
    if(firstName === "undefined" || lastName === "undefined"){
      if (firstName === "undefined" && lastName !== "undefined"){
        return lastName.split("").length < 16 ? lastName : lastName.slice(0,13) + '...'
      } else if(firstName !== "undefined" && lastName === "undefined"){
        return firstName.split("").length < 16 ? firstName : firstName.slice(0,13) + '...'
      }
    }else{
      const full_name = firstName + ' ' + lastName
      return full_name.length > 0 && full_name.split("").length < 16 ? full_name : full_name.slice(0,13) + '...'
    }
  }
  const handleJobFullName = (name) => {
    return name.length < 23 ? name : name.slice(0,20) + '...'
  }
  const handleInterviewModalName = (name) => {
      return name.length < 73 ? name : name.slice(0,70) + '...'
    }
  const handleFullLocation = (location) => {
    return location.length < 20 ? location : location.slice(0,17) + '...'
  }
  return (
    <Fragment >
      <Col xs={12} md={12} style={{marginBottom: '85px'}} >
        <>
          {interviews.data.length > 0 ? interviews.data.map((interview, index) => (
            <>
              <div className={`${styles.dateBorderLeft}`}></div>
                <div className={`${styles.dateWiseData}`}>{interview.date}</div>
              <div className={`${styles.dateBorderRight}`}></div>
              {interview.data.length > 0 ? interview.data.map((data, index) => (
                <Fragment key={index}>
                  <Row>
                    <Col>
                      <div key={index} className={`${styles.tableRowStyle}`}
                        style={{backgroundColor: (backgroundColor.id == index && backgroundColor.active && backgroundColor.matchDate == interview.date) ? '#F6F7FC' :'#FFFFFF'}}
                        onClick={() => {handleIndexValue(index, data, interview.date)
                        }}>
                        <Col xs={12} md={3} onClick={()=>{setModal(true)
                        setFeedbackModal(false)}}>
                          <span className={styles.tdHdLine}>
                            {' '}
                            {interviewStageTime(data.interview_time? data.interview_time : '')}
                          </span>
                        </Col>
                        <Col xs={12} md={2} className={`${styles.profileImage}`} onClick={()=>{setModal(true)
                          setFeedbackModal(false)}}>
                          <img src={data?.avatar_url ? data?.avatar_url : ProfileImage} className={`${styles.imgStyles}`}/>
                          <div className={`${styles.candidateName}`} title={Util.handleUndefinedFullName(data?.first_name, data?.last_name)}>
                            {handleFullName(data?.first_name, data?.last_name)} 
                          </div>
                          <div className={`${styles.candidateLocation}`} title={data?.location}>
                              {data?.location ? handleFullLocation(data?.location) : ''}
                          </div>
                        </Col>
                        <Col xs={12} md={2} style={{paddingLeft: '82px'}}>
                          <div className={`${styles.jobHeader}`} onClick={()=>{setModal(true)
                            setFeedbackModal(false)}}>
                            Job
                          </div>
                          <div className={`${styles.jobtitle}`} onClick={()=>{setModal(true)
                            setFeedbackModal(false)}} title={data?.job_title}>
                            {data?.job_title ? handleJobFullName(data.job_title) : ''}
                          </div>
                        </Col>
                        <Col xs={12} md={2} style={{paddingLeft: '95px'}}>
                          <div className={`${styles.stageHeader}`} onClick={()=>{setModal(true)
                            setFeedbackModal(false)}}>
                            Stage
                          </div>
                          <div className={`${styles.stageType}`} onClick={()=>{setModal(true)
                            setFeedbackModal(false)}}>
                            { (data?.interview_type == 'recruitor_screen') ?
                              "Recruiter screen"
                            : (data?.interview_type ? data.interview_type.replace("_", " ") : '')
                            }
                          </div>
                        </Col>
                        <Col xs={12} md={2} style={{paddingLeft: '160px', top: data?.first_name === "undefined" || data?.last_name === "undefined" ? '-18px' : '-4px'}}>
                          <div className={`${styles.feedbackHeader}`}>
                            Feedback
                          </div>
                          <div className={`${styles.feedbackHeader}`} onClick={()=>{setModal(false)}}>
                            <button type="button" className="btn-demo" data-toggle="modal" data-target="#sideModal" 
                              onClick={()=> {handleFeedbackList(data.id)
                              setDataId(data.id)}}>
                                View Feeds 
                            </button>
                          </div>
                        </Col>
                      </div>
                    </Col>
                  </Row>
                  <Modal
                      className="scheduleModal"
                      show={index === show}
                      onHide={() => setShow(null)}
                      aria-labelledby="contained-modal-title-vcenter"
                      backdropClassName={styles.modalBackdrop}
                      size="xl"
                      centered
                      style={{zIndex: '9999'}}
                  >
                    <Modal.Body className={styles.modalBody}>
                      {isEdit ? (
                        <div className={styles.editScheduleInterviewContainer}>
                          <Row className={styles.editScheduleHead}>
                            <div
                              className={styles.deleteHeader}
                              style={{ marginLeft: '40px', marginBottom: '0px' }}
                            >
                              Reschedule your interview
                            </div>
                            <div style={{ flexGrow: 1 }}></div>
                            <div
                              onClick={() => setShow(null)}
                              className={styles.cancelDelete}
                            >
                              <i className={styles.cancelIcon} data-feather="x" />
                            </div>
                          </Row>
                          <Row className={styles.scheduleInterviewContainer}>
                            <ScheduleInterviewDetails
                              submitText="Send updated invitation for interview"
                              user={user}
                              candidate={interviewDetails}
                              dateselected={backgroundColor.matchDate}
                              interview={interviews}
                              hideModal={setShow}
                              url={endpoint}
                              method='put'
                              jobs={jobs}
                            />
                          </Row>
                        </div>
                        ) : (
                        <RenderDeleteTooltip
                          setDeletePop={setShow}
                          candidate={null}
                          interview={interviewDetails}
                          user={user}
                        />
                      )}
                    </Modal.Body>
                  </Modal>
                  <Modal
                  className="scheduleModal"
                  show={index === showCancelModal}
                  onHide={() => setShowCancelModal(null)}
                  aria-labelledby="contained-modal-title-vcenter"
                  backdropClassName={styles.modalBackdrop}
                  size="xl"
                  style={{zIndex: '9999'}}
                  centered
                  >  
                    <Modal.Body className={styles.modalBody}>
                      <div className={styles.areYouSureText}>
                         Are you sure you want to cancel this interview
                      </div>
                      <div
                        onClick={() => setShowCancelModal(null)}
                        className={styles.cancelDelete}
                        style={{position: 'relative', float: 'right', left: '1064px', top: '-30px'}}
                      >
                        <i className={styles.cancelIcon} data-feather="x" />
                      </div>
                      <button
                        className={styles.yesCancelBtn}
                        onClick={() => {
                          handleCancel(interviewDetails.id)
                        }}
                      >
                        Yes, I want to cancel
                      </button>
                      <button
                      className={styles.noScheduleBtn}
                      onClick={() => {
                          setSwitchButton(true)
                          setShow(indexValue)
                          setShowCancelModal(null)
                          setDeleteModal(false)
                      }}
                      >
                        No, I want to reschedule
                        </button>
                    </Modal.Body>
                 </Modal>
              </Fragment>
              )): ''}
            </>
          )) :
            <>
              <div className={`${styles.noUpcomingInterviews}`}>You have no upcoming interviews!</div>
              <div className={`${styles.noUpcomingInterviewsBorder}`}></div>
            </>
          }
          <div className="row" style={{ position: 'relative', float: 'right', right: '-365px'}}>
            <ScheduledFeedbackModal
              isErrorMessage={isErrorMessage}
              data={data}
              myInterview={myInterview}
              feedbackCancelModal={feedbackCancelModal}
              useOnClickOutside={useOnClickOutside}
              setFeedbackCancelModal={setFeedbackCancelModal}
              handleUpdateModalFeedback={handleUpdateModalFeedback}
              setFeedbackId={setFeedbackId}
              handleModalFeedback={handleModalFeedback}
              handlefeedbackCancel={handlefeedbackCancel}
              setDeleteModal={setDeleteModal}
              feedbackId={feedbackId}
              feedbackModal={feedbackModal}
              setFeedbackModal={setFeedbackModal}
              setModal={setModal}
              errormessageType={errormessageType}
              message={message}
              handleFeedbackList={handleFeedbackList}
            />
          </div>
          <Modal
            className="scheduleModal"
            show={isErrorMessage === false && addModalFeedback || updateModalFeedback}
            onHide={() => setAddModalFeedback(false) || setUpdateModalFeedback(false)}
            aria-labelledby="contained-modal-title-vcenter"
            backdropClassName={styles.modalBackdrop}
            size="xl"
            style={{zIndex: '9999'}}
            centered
          >
            <Modal.Body>
              <div className={`${styles.feedbackModal}`} >
                { isErrorMessage === false && addModalFeedback && <>
                  <h4 class="modalTitle">Add FeedBack</h4>
                  <div
                    onClick={() => setAddModalFeedback(false)}
                    className={styles.cancelDelete}
                    style={{marginTop:"-40px", marginRight:"35px",float:"right"}}
                  >    
                    <i className={styles.cancelIcon} data-feather="x" />
                  </div>
                    <div className={`${styles.modalFeedbackText}`}>
                        Please Enter Your Feedback Here
                    </div>
                    <textarea type="text" className={`${styles.feedbackInputBox}`}
                      onChange={(e)=>{ setFeedbackValue(e.target.value)
                        setFeedbackError(false)}}
                      placeholder="Write feedback here..."
                      defaultValue={feedbackValue}
                    />
                    <div className={`${styles.addModalFeedbackButton}`} onClick={handleSubmit}>
                      <div className={`${styles.addFeedbackText}`}> + Add Feedback </div>
                    </div>
                  {isMessage &&  
                  <Alert style={{width:"30%",marginTop: "107px", textAlign:"center",left: "365px"}}
                  variant={messageType}>{message}</Alert>
                  }
                  {FeedbackError && <p style={{color: "red",marginTop:"36px",marginLeft:"105px"}}>please enter feedback</p>}
                </>
                }
                {updateModalFeedback &&
                  <>
                    <h4 class="modalTitle">Update FeedBack</h4>
                    <div
                    onClick={() => setUpdateModalFeedback(false)}
                    className={styles.cancelFeedbackButton}
                  >    
                    <i className={styles.cancelIcon} data-feather="x" />
                  </div>
                    <div className={`${styles.modalFeedbackText}`}>
                      Please Enter Your Feedback Here
                    </div>
                    <textarea type="text" className={`${styles.feedbackInputBox}`}
                      onChange={(e)=>{ setFeedbackValue(e.target.value)
                        setFeedbackError(false)}}
                      placeholder="Write feeback here..."
                      defaultValue={updateModalFeedback}
                    />
                    <div className={`${styles.addModalFeedbackButton}`} onClick={handleSubmitUpdate}>
                      <div className={`${styles.addFeedbackText}`}> + Update Feedback </div>
                    </div>
                    {isMessage &&  
                      <Alert className={`${styles.feedbackSuccessMessage}`} variant={messageType}>{message}</Alert>
                    }
                    {FeedbackError && <p className={`${styles.feedbackUpdateError}`}>please update feedback</p>}
                  </>  
                }
              </div>
            </Modal.Body>
         </Modal>    
      </>
      </Col>
      {modal && interviews.data.length > 0 && interviewDetails.id  ? 
        <Col xs={12} md={5} > 
          <div ref={ref}>
          <div className={`${styles.candidateInformation}`} style={{height: addFeedback? '570px': openFeedbackMessage? '570px' : '370px'}}>
            <div className={`${styles.cardProfileImage}`}>
            <img src={ProfileImage} className={`${styles.cardImgStyles}`}/>
            <div className={`${styles.cardCandidateName}`}>
            {interviewDetails?.first_name !== "undefined" ? interviewDetails?.first_name : '' } {interviewDetails?.last_name !== "undefined" ? interviewDetails?.last_name : ''}
            </div>
            <div className={`${styles.cardCandidateLocation}`}>
                {interviewDetails.location? interviewDetails.location : ''}
            </div>
            </div>
            <div
              onClick={() => handleModalClick()}
              className={styles.cancelDelete}
              style={{marginTop:"-40px", marginRight:"15px",float:"right"}}
            >    
              <i className={styles.cancelIcon} data-feather="x" />
            </div>
            <div className={`${styles.cardJobHeader}`} >
              Job
            </div>
            <div className={`${styles.cardJobtitle}`} title={interviewDetails?.job_title}>
              {interviewDetails?.job_title ? handleInterviewModalName(interviewDetails.job_title) : ''}
            </div>
            <div className={`${styles.cardStageHeader}`}>
              Stage
            </div>
            <div className={`${styles.cardStageType}`}>
              { (interviewDetails?.interview_type == 'recruitor_screen') ?
                              "Recruiter screen"
                : (interviewDetails?.interview_type ? interviewDetails.interview_type.replace("_", " ") : '')
              }
            </div>      
            <div className={`${styles.contactHeader}`}>
              Contact
            </div>
            {interviewDetails.phone_number && 
            <div className={`${styles.phoneNumber}`}>
              {interviewDetails?.phone_number ? interviewDetails.phone_number : ''}
            </div>
             }
            <div style={{top: interviewDetails?.phone_number == null ? '73px': ''}} className={`${styles.emailAddress}`}>
              {interviewDetails?.email_address ? interviewDetails.email_address : ''}
            </div>
            <div>{interviewDetails.phone_number? <img src={PhoneIcon} className={`${styles.phoneIconStyles}`}/> : ''}</div>
            {interviewDetails?.feedbacks == null ? 
                <div className={`${styles.addFeedbackButton}`} onClick={handleModalFeedback}>
                    <div className={`${styles.addFeedbackText}`}> + Add Feedback </div>
                    {isErrorMessage && <Alert className={`${styles.FeedbackErrorMsg}`} variant={errormessageType}>{message}</Alert>}
                </div>
                :  <div className={`${styles.updateFeedbackButton}`} >
                     <div type="button" className={`${styles.updateFeedbackText}`} data-toggle="modal" data-target="#sideModal" onClick={()=>handleFeedbackList(feedbackId)}>
                       Show Feedback
                     </div>
            </div>
            }
            <div>{interviewDetails.email_address?<img src={EmailIcon} style={{top: interviewDetails?.phone_number == null ? '18px': '4px'}}className={`${styles.emailIconStyles}`}/> : ''}</div>
            <div style={{background: modal?"" : ""}} className={`${styles.messageIcon}`} onClick={()=> { handleMessageClick() } }>
              <div className={`${styles.messageIconStyles}`}>...</div>
            </div>
            {messageOpen?
              <div className={`${styles.groupButtonBox}`}>
                <Button className={`${styles.buttonRescheduleCancel}`}
                  style={{background: switchButton? '#F6F7FC' : '#FFFFFF'}}
                  onClick={() => {
                      setSwitchButton(true)
                      setShow(indexValue)
                  }}>
                  <div className={`${styles.buttonStylesReschedule}`}>Reschedule</div>
                </Button>
                <Button className={`${styles.buttonRescheduleCancel}`}
                  style={{background: !switchButton? '#F6F7FC' : '#FFFFFF'}}
                  onClick={() => {
                      setSwitchButton(false)
                      setShowCancelModal(indexValue)
                  }}>
                  <div className={`${styles.buttonStylesCancel}`}>Cancel</div>
                </Button>
              </div> : ''
            }
            {addFeedback?
              <>
                <div className={`${styles.feedbackText}`} style={{top: messageOpen? '-28px': '52px'}}>
                  Press “Enter” to submit your feedback
                </div>
                <textarea type="text" className={`${styles.feedbackInputBox}`}
                  style={{top: messageOpen? '-16px': '64px'}}
                  onChange={(e)=>{ setFeedbackValue(e.target.value)
                    setFeedbackError(false)}}
                  onKeyPress={handleKeyPress}
                  placeholder="Write feeback here..."
                  defaultValue={feedbackValue}
                />
              {isMessage &&  
                <Alert className={styles.succesAlertMeg} severity={messageType}>{message}</Alert>
              }
              {FeedbackError && <p className={`${styles.feedbackAddError}`}>please enter feedback</p>}
              </>
              :  openFeedbackMessage && interviewDetails.feedbacks? <> 
              <div className={`${styles.feedbackText}`} style={{top: messageOpen? '-28px': '52px'}}>
                   Press “Enter” to update your feedback
               </div>
               <textarea type="text" className={`${styles.feedbackInputBox}`}
               style={{top: messageOpen? '-16px': '64px'}}
               onChange={(e)=> setFeedbackValue(e.target.value)}
               onKeyPress={handleUpdateKeyPress}
               defaultValue={interviewDetails.feedbacks}
               />
               {/* {isMessage &&  
                <Alert className={styles.succesAlertMeg} severity={messageType}>{message}</Alert>
               } */}
            </>
            : ''
              }
              { FeedbackError && <p style={{color: "red", marginTop: "65px", marginLeft: "30px"}}>Please Enter Feedback</p>}
              
              </div>
          </div>
        </Col>
      : '' }
    </Fragment>
  )
}

export function useOnClickOutside(ref, handler) {
  useEffect(
    () => {
      const listener = (event) => {
        if (!ref.current || ref.current.contains(event.target)) {
          return;
        }
        handler(event);
      };
      document.addEventListener("mousedown", listener);
      document.addEventListener("touchstart", listener);
      return () => {
        document.removeEventListener("mousedown", listener);
        document.removeEventListener("touchstart", listener);
      };
    },
    [ref, handler]
  );
}

export default SheduledTableBody
