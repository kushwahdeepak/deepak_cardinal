import React, { useEffect, useState, useContext, useRef } from 'react'
import feather from 'feather-icons'
import { Row, Col, Alert, Button, Dropdown, Tab, Nav, Image, Spinner } from 'react-bootstrap'
import axios from 'axios'
import moment from 'moment'
import { nanoid } from 'nanoid'
import _ from 'lodash'

import styles from './styles/CandidateInfoPanel.module.scss'
import ResumeIcon from '../../../../assets/images/icons/resume-icon.svg'
import GithubIcon from '../../../../assets/images/icons/github-icon.svg'
import LinkedinIcon from '../../../../assets/images/icons/linkedin-icon.svg'
import UploadIcon from '../../../../assets/images/icons/upload-icon.svg'
import UrlIcon from '../../../../assets/images/icons/url-link-icon.svg'
import PlusIcon from '../../../../assets/images/icons/plus-icon-v2.svg'
import PhoneIcon from '../../../../assets/images/icons/phone-icon.svg'
import MailIcon from '../../../../assets/images/icons/mail-icon.svg'
import AddNote from '../AddNote/AddNote'
import { makeRequest } from '../RequestAssist/RequestAssist'
import Util from '../../../utils/util'
import { StoreDispatchContext } from '../../../stores/JDPStore'
import './styles/CandidateInfoPanel.scss'
import { useOnClickOutside } from '../ScheduleInterviwes/ScheduledTable/SheduledTableBody'

function isPhoneValid(phone_number) {
    if (phone_number === '') return true
    var phoneRegex = /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/
    return phoneRegex.test(phone_number)
}

function isEmailValid(email) {
    if (email === '' || email == null || email == undefined) return false
    const email_regex = /^\S+@\S+[\.][0-9a-z]+$/
    return email_regex.test(email)
}



function isUrlValid(linkedin_url) {
    if ( linkedin_url == null || linkedin_url == undefined) return false
    let url = /^([A-Za-z0-9]+@|http(|s)\:\/\/)([A-Za-z0-9.]+(:\d+)?)(?::|\/)([\d\/\w.-]+?)(\.linkedin)?$/i
    return url.test(linkedin_url)
}

function isUrlGithubValid(github_url) {
    if ( github_url == null || github_url == undefined) return false
    
    let url = /^([A-Za-z0-9]+@|http(|s)\:\/\/)([A-Za-z0-9.]+(:\d+)?)(?::|\/)([\d\/\w.-]+?)(\.git)?$/i
    
    return url.test(github_url)
}

const allStages = [
    { id: 'lead', label: 'Leads' },
    { id: 'applicant', label: 'Applicants' },
    { id: 'recruitor_screen', label: 'Recruiter Screen' },
    { id: 'submitted', label: 'Submitted' },
    { id: 'first_interview', label: 'First interview' },
    { id: 'second_interview', label: 'Second interview' },
    { id: 'offer', label: 'Offer' },
    { id: 'reject', label: 'Archive' },
]

const source = [
  {id:"sign_in", label: "Registration"},
  {id:"incoming_mail", label: 'Incoming Mail'},
  {id:"linkedin", label: "Linkedin"},
  {id:"salesql_phone", label: "Phone"},
  {id:"salesql_email", label: "Email"},
  {id:"applicant", label: "Applicant"},
  {id:"indeed", label:"Indeed"},
  {id:"bulk_upload", label:"Bulk Upload"},
  {id:"zoom_info", label:"Zoom Info"},
  {id:'direct', label:"Direct"}
]
const fileTypes = [
    'application/msword',
    'application/pdf',
    'application/docx',
    'text/plain',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
]

function CandidateInfoPanel({
    user,
    candidate,
    closeFunc,
    showUploadCandidatePanel,
    handleScheduleButtonClick,
    page,
    setPage,
    pageCount,
    jobId,
    currentOrganization,
    allowCandidateUpload,
    reloadCandidateData,
    memberOrganization,
    setReloadCandidateData
}) {
    const { dispatch, state } = useContext(StoreDispatchContext)
    const [notes, setNotes] = useState([])
    const [candidateSubmited, setCandidateSubmited] = useState(false)
    const [errorFetchingCandidate, setErrorFetchingCandidate] = useState(null)
    const [resume, setResume] = useState(null)
    const [resumeUrl, setResumeUrl] = useState(null)
    const [noteAdded, setNoteAdded] = useState(false)
    // const [email, setEmail] = useState('')
    // const [phoneNumber, setPhoneNumber] = useState('')
    const [linkedinUrl, setLinkedinUrl] = useState('')
    const [githubUrl, setGithubUrl] = useState('')
    const [experience,setExperience] = useState([])
    const [loading, setLoading] = useState(false)
    const [candidateUploadData, setCandidateUploadData] = useState({
        name: '',
        title: '',
        company: '',
        location: '',
        linkedin_profile_url: [''],
        github_url: [''],
        school: '',
        experiences:'',
        job_experiences: [],
        skills: [],
        emails: [''],
        phone_numbers: [''],
        links: [],
        files: [],
        stage:'lead',
        source:'sign_in'
    })
    const [validationErrors, setValidationErrors] = useState({})
    const [isEditable, setIsEditable] = useState(false)
    const ref = useRef();

    useEffect(() => {
        feather.replace()
    })

    useEffect(() => {
        if (noteAdded && candidate) {
            axios
                .get(`/people/${candidate.id}.json`)
                .then((res) => {
                  setNotes(res.data.notes) 
                })
                .catch((e) => console.log(e.message))
            setNoteAdded(false)
        }
    }, [noteAdded])

    useEffect(() => {
        if (candidate != null) {
            setLoading(true)
            let candidateDetails = {
                id: candidate.id,
                name: candidate.first_name + ' ' + candidate.last_name,
                first_name: candidate.first_name,
                linkedin_profile_url: [candidate.linkedin_profile_url],
                github_url: [candidate.github_url],
                last_name: candidate.last_name,
                title: candidate.title,
                company: candidate.company_names,
                location: candidate.location,
                school: candidate.school,
                experiences: candidate.experiences,
                job_experiences:[],
                skills: candidate?.skills ? candidate?.skills?.split(',') : "",
                emails: [candidate.email_address],
                phone_numbers: [candidate.phone_number],
                links: candidate.links,
                files: [],
            }
            axios
                .get(`/people/${candidate.id}.json`)
                .then((res) => {
                    setCandidateUploadData({
                        ...candidateDetails,
                        links: res.data.person.links,
                        linkedin_profile_url: res.data.person.linkedin_profile_url,
                        github_url: res.data.person.github_url,
                        job_experiences: res.data.job_experiences || [],       
                    })
                    setExperience(res.data.job_experiences || [] )
                    setNotes(res.data.notes)
                    setResume(res.data.resume)
                    setResumeUrl(res.data.resume_url)
                    setIsEditable(res.data.is_editable)
                    setLoading(false)
                })
                .catch((e) => {
                    setErrorFetchingCandidate(e.message)
                    setLoading(false)
                })
        }
    }, [candidate, candidateSubmited])

    /**
     *
     * @param {string} skills  Candidate skills
     * @returns  Array of strings
     */
    const formatSkills = (skills) => {
        if (!skills) {
            return []
        }
        if (Array.isArray(skills) && skills?.length) {
            return skills.filter((ele) => ele != '')
        } else if (typeof skills === 'string' && skills?.length) {
            return skills.split(',') ?? []
        }
        return []
    }

    const close = () => {
        closeFunc()
    }
    useOnClickOutside(ref, close);


    const displaySkills = (skills) => {
        if (!skills) return null
        return formatSkills(skills).map((skill, index) => (
            <div className={styles.skillBadge} key={`${index} ${skill}`}>
                <div>{skill}</div>{' '}
               { (isEditable || allowCandidateUpload) &&  
                  <a
                    style={{ marginLeft: '10px', cursor: 'pointer' }}
                    onClick={(event) => removeItem(event, skill, 'skills', index)}
                >
                    x
                </a>
               }
            </div>
        ))
    }

    useEffect(() => {
        if (state.nextCandidateId != null) {
            dispatch({
                type: 'show_candidate',
                candidate: state.candidates[state.nextCandidateId],
            })
            dispatch({
                type: 'remove_show_next_candidate',
            })
        }
    }, [state.candidates])

    const showNextCandidate = (currentlyDisplayedCandidate) => {
        const currentCandidateIndex = state.candidates.indexOf(
            currentlyDisplayedCandidate
        )

        if (
            page + 1 >= pageCount &&
            currentCandidateIndex + 1 >= state.candidates.length
        )
            return

        dispatch({
            type: 'hide_candidate',
        })

        if (currentCandidateIndex + 1 >= state.candidates.length) {
            dispatch({
                type: 'set_show_next_candidate',
                index: 0,
            })
            setPage(page + 1)
        } else {
            const nextIndex = currentCandidateIndex + 1
            dispatch({
                type: 'show_candidate',
                candidate: state.candidates[nextIndex],
            })
        }
    }

    const showPrevCandidate = (currentlyDisplayedCandidate) => {
        const currentCandidateIndex = state.candidates.indexOf(
            currentlyDisplayedCandidate
        )
        if (page == 0 && currentCandidateIndex - 1 < 0) return
        dispatch({
            type: 'hide_candidate',
        })

        if (currentCandidateIndex - 1 < 0) {
            dispatch({
                type: 'set_show_next_candidate',
                index: 24,
            })
            setPage(page - 1)
        } else {
            const nextIndex = currentCandidateIndex - 1
            dispatch({
                type: 'show_candidate',
                candidate: state.candidates[nextIndex],
            })
        }
    }

    const modifySkills = (skills, item) => {
      var skills = skills.concat(',', item).split(",")
      var updatedSkills = new Map(skills.map(s => [s, s.toLowerCase()]));
      updatedSkills = [...updatedSkills.values()]
      return [...new Set(updatedSkills)].join()
    }

    const submitCandidateDataForm = async (event, item, controlName) => {
        
        const modifiedCandidate = { ...candidate }
        event.preventDefault()
        const url = `/people/${candidate.id}.json`
        const formData = new FormData()

        switch (controlName) {
            case 'experience':
                modifiedCandidate.job_experiences = item
                break
            case 'skills':
                if (item.length == 0) {
                  break
                }
                modifiedCandidate.skills =
                    modifiedCandidate.skills.length > 0
                        ? modifySkills(modifiedCandidate.skills, item)
                        : item
                break
            case 'phone_numbers':
                modifiedCandidate.phone_number = item
                break
            case 'emails':
                modifiedCandidate.email_address = item
                break
            case 'linkedin_profile_url':
                modifiedCandidate.linkedin_profile_url = item
                break
            case 'github_url':
                modifiedCandidate.github_url = item
                break        
            case 'links':
                modifiedCandidate.links =
                    modifiedCandidate.links.length > 0
                        ? item ? [ ...new Set(modifiedCandidate.links.concat(item))] : modifiedCandidate.links
                        : item ? [item] : item
                break
            case 'files':
                formData.append('person[resume]', item)
                break
            default:
                break
        }   
        formData.append(
            'person[company_names]',
            modifiedCandidate.company_names
        )
        formData.append('person[skills]', modifiedCandidate.skills)
        formData.append('person[phone_number]', modifiedCandidate.phone_number)
        formData.append(
            'person[email_address]',
            modifiedCandidate.email_address
        )

        formData.append('person[first_name]', modifiedCandidate.first_name)
        formData.append('person[last_name]', modifiedCandidate.last_name)
        formData.append('person[school]', modifiedCandidate.school)
        formData.append(
            'person[experiences]',
            JSON.stringify(candidateUploadData.job_experiences)
        )
        formData.append(
            'person[links]',
            JSON.stringify(modifiedCandidate.links)
        )
        formData.append('person[linkedin_profile_url]',
                (modifiedCandidate.linkedin_profile_url)
        )
        formData.append('person[github_url]',
                (modifiedCandidate.github_url)
        )
        if(jobId){ 
            formData.append('job_id', jobId)
        }
        const response = await makeRequest(url, 'put', formData, {
            contentType: 'multipart/form-data',
            loadingMessage: 'Submitting...',
            onError: (error) => {
                dispatch({
                    type: 'update_candidate',
                    candidate,
                })
                dispatch({
                    type: 'show_candidate',
                    candidate,
                })
            },
            createResponseMessage: (response) => {
                return {
                    message: response.data
                        ? response.data.message
                        : 'Update successful',
                    messageType: 'success',
                    loading: false,
                    autoClose: true,
                }
            },
        })
        dispatch({
            type: 'update_candidate',
            candidate: modifiedCandidate,
        })
        dispatch({
            type: 'show_candidate',
            candidate: modifiedCandidate,
        })
        window.scrollTo({ top: 0, behavior: 'smooth' })
    }

    const submitSingleCandidate = async (event) => {
        const candidateData = { ...candidateUploadData }
        const phone_numbers_valid = candidateData.phone_numbers.some(
            (phone) => isPhoneValid(phone) == false
        )
        const emails_valid = candidateData.emails.some(
            (email) => isEmailValid(email) == false
        )
        if (emails_valid || candidateData.emails.length == 0) {
            setValidationErrors({
                ...validationErrors,
                error: 'Invalid email format',
            })
            return
        }

        if (candidateData.phone_numbers[0].length === 0) {
            setValidationErrors({
                ...validationErrors,
                error: 'Please enter Phone Number',
            })
            return
        }

        if (!isPhoneValid(candidateData.phone_numbers[0])) {
            setValidationErrors({
                ...validationErrors,
                error: 'Invalid phone number',
            })
            return
        }

        if (candidateData.name.length === 0) {
            setValidationErrors({
                ...validationErrors,
                error: 'Candidate name is empty!',
            })
            return
        }

        if (candidateData.title.length === 0){
            setValidationErrors({
                ...validationErrors,
                error:'Please enter Position'
            })
            return
        }

        if (candidateData.company.length === 0){
            setValidationErrors({
                ...validationErrors,
                error: 'Please enter Current company'
            })
            return
        }   

        if (candidateData.location.length === 0){
            setValidationErrors({
                ...validationErrors,
                error: 'Please enter Location'
            })
            return
        }

        if (candidateData.school.length === 0){
            setValidationErrors({
                ...validationErrors,
                error: 'Please enter University'
                
            })
            return
        }

        if (candidateData.skills.length == 0) {
            setValidationErrors({
                ...validationErrors,
                error: 'Please enter skills',
            })
            return
        }

        if (candidateData.files.length == 0) {
            setValidationErrors({
                ...validationErrors,
                error: 'Please upload resume',
            })
            return
        }

        if (!fileTypes.includes(candidateData.files[0].type)) {
            setValidationErrors({
                ...validationErrors,
                error:`Invalid file format`
            }) 
            return
        }

        if (candidateData.linkedin_profile_url[0].length === 0) {
            setValidationErrors({
                ...validationErrors,
                error: 'Please enter linkedin URL',
            })
            return
        }

        if (!isUrlValid(candidateData.linkedin_profile_url[0])) {
            setValidationErrors({
                ...validationErrors,
                error: 'Please insert correct linkedin URL',
            })
            return
        }

        if (candidateData.github_url[0].length > 0) {
            if (!isUrlGithubValid(candidateData.github_url[0])) {
                setValidationErrors({
                    ...validationErrors,
                    error: 'Please insert correct github URL',
                })
                return
            }
        }

        event.preventDefault()
        const url = `/people/new/single_candidate`
        const formData = new FormData()

        if (candidate != null) {
            formData.append('id', candidateData.id)
        }
        formData.append('person[first_name]', candidateData.name.split(' ')[0])
        formData.append('person[last_name]', candidateData.name.split(' ')[1])
        formData.append('person[title]', candidateData.title)
        formData.append('person[company_names]', candidateData.company)
        formData.append('person[location]', candidateData.location)
        formData.append('person[school]', candidateData.school)
        formData.append(
            'person[experiences]',
            JSON.stringify(candidateData.job_experiences)
        )
        formData.append('person[skills]', candidateData.skills.join(','))
        formData.append('person[email_address]', candidateData.emails[0])
        formData.append('person[links]', JSON.stringify(candidateData.links))
        formData.append('person[phone_number]', candidateData.phone_numbers[0])
        formData.append('person[organization_id]', currentOrganization?.id)
        formData.append('person[linkedin_profile_url]',candidateData.linkedin_profile_url)
        formData.append('person[github_url]', candidateData.github_url || '')
        if (candidateData.files[0])
            formData.append('person[resume]', candidateData.files[0])
        formData.append('job_id', jobId)
        formData.append('stage',candidateData.stage)
        formData.append('person[source]',candidateData.source )

        const response = await makeRequest(url, 'post', formData, {
            contentType: 'multipart/form-data',
            loadingMessage: 'Submitting...',
            createResponseMessage: (response) => {
                return response.msg
            },
            onError: (error) => {
                dispatch({
                    type: 'update_candidate',
                    candidate,
                })
                dispatch({
                    type: 'show_candidate',
                    candidate,
                })
            },
        })
        setCandidateUploadData({
            name: '',
            title: '',
            company: '',
            location: '',
            school: '',
            experiences:'',
            job_experiences: [],
            skills: [],
            emails: [''],
            phone_numbers: [''],
            links: [],
            files: [],
            linkedin_profile_url: [''],
            github_url: [''],
            stage: 'lead',
            source:'sign_in'
        })
        setValidationErrors({})
        close()
        window.location.reload();
    }
    const findLable = (value, list) => {
        const newLable = list.find((item) => item.id === value)
        return newLable?.label
    }
    
    const showExperienceForm = () => {
        const newExperience = {
            id: nanoid(),
            title: '',
            company_name: '',
            location: '',
            start_date: '',
            end_date: '',
            description: '',
        }

        setCandidateUploadData({
            ...candidateUploadData,
            job_experiences: [...candidateUploadData.job_experiences, newExperience],
        })
    }

    const addNewExperience = (exp) => {
        setCandidateUploadData({
            ...candidateUploadData,
            job_experiences: candidateUploadData.job_experiences.map((e) => {
                if (e.id === exp.id) return exp
                else return e
            }),
        })
    }

    const removeExperience = (exp) => {
        if(exp.person_id){
            const url = `/job_experiences/delete/${exp.id}`
            makeRequest(url, 'get', '').then((res) => {
                setCandidateUploadData({
                    ...candidateUploadData,
                    job_experiences: candidateUploadData.job_experiences.filter(
                        (e) => e.id != exp.id
                    ),
                })
            })
        }else{
            setCandidateUploadData({
                ...candidateUploadData,
                job_experiences: candidateUploadData.job_experiences.filter(
                    (e) => e.id != exp.id
                ),
            })
        }
        
       
    }


    const addItem = (e, item, control) => {
        let links = [...candidateUploadData[control], item]
        setCandidateUploadData({
            ...candidateUploadData,
            [control]: [...new Set(links)],
        })
    }

    const removeItem = (event, item, control, index) => {
        event.preventDefault()
        setCandidateUploadData({
          ...candidateUploadData,
          [control]: candidateUploadData[control].filter((e, idx) =>
                e === item && idx == index ? false : true
            ),
        })
        if (candidate && control === "skills") {
            var skills = candidate.skills
            candidate.skills = skills.split(",").filter((e) => e !== item).join()
            submitCandidateDataForm(event, '', control)
        }

        if (candidate && control === "links") {
            var links = candidate.links
            candidate.links = links.filter((e) => e !== item)
            submitCandidateDataForm(event,'', control)
        }
    }

    const handleChange = (e) => {
        setCandidateUploadData({
            ...candidateUploadData,
            [e.target.name]: e.target.value,
        })
    }

    const handleEmail = (event) => {
        const clone = candidateUploadData.emails.slice()
        clone[0] = event.target.value
        setValidationErrors({})
        setCandidateUploadData({
            ...candidateUploadData,
            emails: clone,
        })
    }

    const handleLinkedinUrl = (event) => {
        const clone = candidateUploadData.linkedin_profile_url.slice()
        clone[0] = event.target.value
        setValidationErrors({})
        setCandidateUploadData({
            ...candidateUploadData,
            linkedin_profile_url: clone,
        })
    }

    const handleGithubUrl = (event) => {
        const clone = candidateUploadData.github_url.slice()
        clone[0] = event.target.value
        setValidationErrors({})
        setCandidateUploadData({
            ...candidateUploadData,
            github_url: clone,
        })
    }

    const handelPhoneNumber = (event) => {
        const clone = candidateUploadData.phone_numbers.slice()
        clone[0] = event.target.value
        setValidationErrors({})
        setCandidateUploadData({
            ...candidateUploadData,
            phone_numbers: clone,
        })
    }

    const showItems = (control) => {
        const getHostname = (url) => {
            try {
                return new URL(url).hostname
            } catch (error) {
                return null
            }
        }


        function getIcon(item) {
            let icon

            switch (control) {
                case 'emails':
                    icon = (
                        <Image
                            src={MailIcon}
                            style={{
                                width: '15px',
                                height: '15px',
                                marginRight: '15px',
                            }}
                        />
                    )
                    break
                case 'phone_numbers':
                    icon = (
                        <Image
                            src={PhoneIcon}
                            style={{
                                width: '15px',
                                height: '15px',
                                marginRight: '15px',
                            }}
                        />
                    )
                    break
                case 'links':
                    icon = (
                        <Image
                            src={
                                getHostname(item) === 'linkedin.com'
                                    ? LinkedinIcon
                                    : getHostname(item) === 'github.com'
                                    ? GithubIcon
                                    : UrlIcon
                            }
                            style={{
                                width: '15px',
                                height: '15px',
                                marginRight: '15px',
                            }}
                        />
                    )
                    break
                case 'files':
                    icon = (
                        <Image
                            src={ResumeIcon}
                            style={{
                                width: '15px',
                                height: '15px',
                                marginRight: '15px',
                            }}
                        />
                    )
                    break
                default:
                    break
            }

            return icon
        }

        return (
            <>
                {candidateUploadData[control].map((e, idx) => {
                    if (
                        (control === 'emails' || control === 'phone_numbers') &&
                        idx == 0
                    )
                        return null
                    return (
                        <p key={idx} className={styles.urlText}>
                            {getIcon(e)}
                            <span          
                                style={{
                                    width: '150px',
                                    textOverflow: 'ellipsis',
                                    display: 'inline-block',
                                    overflowX: 'hidden',
                                }}
                            >
                                <a href={e} target="_blank">{control === 'files' ? e.name : e}</a>
                            </span>
                           { (allowCandidateUpload || isEditable) && 
                              <a
                                onClick={(event) => {
                                    removeItem(event, e, control, idx)
                                }}
                            >
                                <i
                                    data-feather="x"
                                    style={{
                                        width: '10px',
                                        height: '10px',
                                        marginLeft: '15px',
                                        color: 'red',
                                        cursor: 'pointer',
                                    }}
                                ></i>
                            </a>
                            }
                        </p>
                    )
                })}
            </>
        )
    }

    if (candidate || showUploadCandidatePanel) {
        return (
            <div
                ref={ref}
                className={`${styles.infoPanel} candidate-info-panel`}
            >
                <Row className="d-flex justify-content-between">
                    <Col xs={8} className="d-flex position-relative w-100">
                        {candidate ? (
                            <>
                                <Button
                                    onClick={(e) => {
                                        dispatch({
                                            type: 'update_schedule_modal_data',
                                            data: {
                                                candidate:
                                                    state.displayedCandidate,
                                            },
                                        })
                                        dispatch({
                                            type: 'hide_candidate',
                                            candidate: null,
                                        })
                                        handleScheduleButtonClick()
                                    }}
                                    className={styles.topRowButton}
                                >
                                    Schedule
                                </Button>
                                <Button className={styles.topRowButton}>
                                    Contact
                                </Button>

                                <AddNote
                                    candidate={candidate}
                                    setNoteAdded={setNoteAdded}
                                />
                            </>
                        ) : (
                            <p className={styles.uploadTitle}>
                                Single Candidate Upload
                            </p>
                        )}
                    </Col>
                    <Col xs={4} className="d-flex justify-content-end">
                        {candidate && (
                            <>
                                <div
                                    className={styles.circleButton}
                                    onClick={() => showPrevCandidate(candidate)}
                                    style={{
                                        pointerEvents:
                                            page == 0 &&
                                            state.candidates.length > 0 &&
                                            state.candidates[0].id ===
                                                candidate.id
                                                ? 'none'
                                                : 'all',
                                    }}
                                >
                                    <i data-feather="chevron-left" />
                                </div>
                                <div
                                    className={styles.circleButton}
                                    onClick={() => showNextCandidate(candidate)}
                                    style={{
                                        pointerEvents:
                                            page + 1 >= pageCount &&
                                            state.candidates.slice().pop()
                                                .id === candidate.id
                                                ? 'none'
                                                : 'all',
                                    }}
                                >
                                    <i data-feather="chevron-right" />
                                </div>
                            </>
                        )}
                        <div
                            className={styles.circleButton}
                            style={{ background: '#4C68FF', color: '#fff' }}
                            onClick={close}
                        >
                            <i
                                data-feather="x"
                                style={{ width: '15px', height: '15px' }}
                            />
                        </div>
                    </Col>
                </Row>
                {errorFetchingCandidate && (
                    <Alert
                        variant="danger"
                        onClose={() => setErrorFetchingCandidate(null)}
                        dismissible
                        className="candidate-info-close"
                    >
                        {errorFetchingCandidate}
                    </Alert>
                )}
                <Row className={styles.contentRow}>
                    <Col xs={8} className={styles.contentRowLefColumn}>
                        {candidate ? (
                            <>
                                <p className={styles.nameText}>
                                    {Util.handleUndefinedFullName(candidate?.first_name, candidate?.last_name)}
                                </p>
                                <Row>
                                    <Col
                                        xs={12}
                                        md={12}
                                        style={{ paddingLeft: 0 }}
                                    >
                                        <p className={styles.personalInfoText}>
                                            {candidate?.company_names}
                                        </p>
                                        <p className={styles.personalInfoText}>
                                            {candidate?.location}
                                        </p>
                                        <p className={styles.personalInfoText}>
                                            {candidate?.school}
                                        </p>
                                        <p className={styles.personalInfoText}>
                                            {candidate.title}
                                        </p>
                                    </Col>
                                </Row>
                            </>
                        ) : (
                            <>
                                <div className="d-flex justify-content-between">
                                    <input
                                        type="text"
                                        name="name"
                                        placeholder="Candidate name*"
                                        className={`${styles.editInput} ${styles.editCandidateName}`}
                                        value={candidateUploadData.name}
                                        onChange={handleChange}
                                    />
                                   <div>
                                       <span className={styles.labelText}>Stage</span>
                                    <Dropdown
                                        className={`${styles.stageDopDown}`}
                                    >
                                        <Dropdown.Toggle
                                            className={`${styles.stageToggle}`}
                                        >
                                            {findLable(
                                                candidateUploadData.stage,allStages
                                            )}
                                        </Dropdown.Toggle>
                                        <Dropdown.Menu>
                                            {allStages.map(
                                                (stage, stageIndex) => (
                                                    <Dropdown.Item
                                                        key={stageIndex}
                                                        onSelect={(e) => {
                                                            setCandidateUploadData(
                                                                {
                                                                    ...candidateUploadData,
                                                                    stage: e,
                                                                }
                                                            )
                                                        }}
                                                        value={stage.id}
                                                        eventKey={stage.id}
                                                    >
                                                        {stage.label}
                                                    </Dropdown.Item>
                                                )
                                            )}
                                        </Dropdown.Menu>
                                    </Dropdown>
                                    </div>
                                </div>
                                <div className="d-flex align-items-center">
                                    <input
                                        type="text"
                                        name="title"
                                        placeholder="Position*"
                                        className={styles.editInput}
                                        value={candidateUploadData.title}
                                        onChange={handleChange}
                                        style={{ width: '90px' }}
                                    />
                                    <span className={styles.symbolText}>@</span>
                                    <input
                                        type="text"
                                        name="company"
                                        placeholder="Current company*"
                                        className={styles.editInput}
                                        value={candidateUploadData.company}
                                        onChange={handleChange}
                                        style={{ width: '145px' }}
                                    />
                                </div>
                                <div>
                                    <input
                                        type="text"
                                        name="location"
                                        placeholder="Location*"
                                        className={styles.editInput}
                                        value={candidateUploadData.location}
                                        onChange={handleChange}
                                        style={{ width: '250px' }}
                                    />
                                </div>
                                <div>
                                    <input
                                        type="text"
                                        name="school"
                                        placeholder="University*"
                                        className={styles.editInput}
                                        value={candidateUploadData.school}
                                        onChange={handleChange}
                                        style={{ width: '250px' }}
                                    />
                                </div>
                                {/* <Button className={styles.uploadButton}>
                                    <Image
                                        src={UploadIcon}
                                        width={10}
                                        height={10}
                                    />{' '}
                                    <span style={{ marginLeft: '10px' }}>
                                        Upload Resume
                                    </span>
                                </Button> */}
                            </>
                        )}

                        <Tab.Container defaultActiveKey="about_candidate">
                            {candidate && (
                                <Row className={styles.tabContainer}>
                                    <Nav variant="pills">
                                        <Nav.Item>
                                            <Nav.Link
                                                eventKey="about_candidate"
                                                className={styles.tabButton}
                                            >
                                                About Candidate
                                            </Nav.Link>
                                        </Nav.Item>
                                        <Nav.Item>
                                            <Nav.Link
                                                eventKey="recruiter_activity"
                                                className={styles.tabButton}
                                            >
                                                Recruiter Activity
                                            </Nav.Link>
                                        </Nav.Item>
                                    </Nav>
                                </Row>
                            )}

                            <Row className={styles.tabContent}>
                              {loading ? (
                                <div className="d-flex justify-content-center">
                                    <Spinner animation="border" role="status">
                                        <span className="sr-only">Loading...</span>
                                    </Spinner>
                                </div>
                                ) : (
                                <Tab.Content style={{ width: '100%' }}>
                                    <Tab.Pane eventKey="about_candidate">
                                        <p className={styles.tabContentTitle}>
                                            Experience
                                        </p>

                                        <div
                                            className={`${styles.indent} ${styles.tabContentText}`}
                                            style={{
                                                cursor: 'pointer',
                                                border: '1px solid #435ad4',
                                                borderRadius: '2px',
                                                padding: '12px',
                                                marginBottom: '12px',
                                                marginLeft:'0px'
                                            }}
                                        >
                                            {candidateUploadData.job_experiences.map(
                                                (exp) => (
                                                    <AddNewExperience
                                                        key={exp.id}
                                                        experience={exp}
                                                        onChange={
                                                            addNewExperience
                                                        }
                                                        removeExperience={
                                                            removeExperience
                                                        }
                                                        isEditable={isEditable}
                                                        allowCandidateUpload={
                                                            allowCandidateUpload
                                                        }
                                                    />
                                                )
                                            )}

                                            <div className="d-flex justify-content-between align-items-center">
                                                <p
                                                    style={{
                                                        cursor: 'pointer',
                                                        marginBottom: '0px',
                                                    }}
                                                >
                                                    {(allowCandidateUpload ||
                                                        isEditable) && (
                                                        <a
                                                            onClick={() =>
                                                                showExperienceForm()
                                                            }
                                                        >
                                                            <Image
                                                                src={PlusIcon}
                                                                style={{
                                                                    width: '10px',
                                                                    height: '10px',
                                                                    marginRight:
                                                                        '15px',
                                                                }}
                                                            />
                                                            Add experience
                                                        </a>
                                                    )}
                                                </p>
                                            </div>
                                        </div>
                                        <p className={styles.tabContentTitle}>
                                            Skills*
                                        </p>

                                        <div className={styles.skillContainer}>
                                            {((candidate && candidate.skills) ||
                                                candidateUploadData.skills
                                                    .length > 0) && (
                                                <div
                                                    className={`${styles.indent} ${styles.skillscontent} mb-3 d-flex flex-wrap`}
                                                >
                                                    {displaySkills(
                                                        candidate
                                                            ? candidate.skills
                                                            : candidateUploadData.skills
                                                    )}
                                                </div>
                                            )}
                                        </div>

                                        <div
                                            className={`${styles.indent} ${styles.tabContentText}`}
                                            style={{ cursor: 'pointer' }}
                                        >
                                            {(allowCandidateUpload ||
                                                isEditable) && (
                                                <AddButton
                                                    title="Add Skill"
                                                    controlName="skills"
                                                    update={
                                                        candidate
                                                            ? submitCandidateDataForm
                                                            : addItem
                                                    }
                                                    candidate={candidate}
                                                />
                                            )}
                                        </div>
                                    </Tab.Pane>
                                    <Tab.Pane eventKey="recruiter_activity">
                                        <p className={styles.tabContentTitle}>
                                            NOTES
                                        </p>
                                        <div>
                                            {notes.map((note) => {
                                                return (
                                                    <RecruiterActivityItem
                                                        key={note.id}
                                                        author={note.user}
                                                        created_at={
                                                            note.created_at
                                                        }
                                                        title={note.user?.email}
                                                        content={note.body}
                                                    />
                                                )
                                            })}
                                        </div>
                                        <p className={styles.tabContentTitle}>
                                            FEEDBACK
                                        </p>

                                        <p className={styles.tabContentTitle}>
                                            ACTIVITY
                                        </p>
                                    </Tab.Pane>
                                </Tab.Content> )}
                            </Row>
                        </Tab.Container>

                        {!candidate && (
                            <div className={styles.sourceWrapper}>
                                <span className={styles.labelText}>Source</span>
                                <Dropdown className={`${styles.stageDopDown}`}>
                                    <Dropdown.Toggle
                                        className={`${styles.stageToggle}`}
                                    >
                                        {findLable(
                                            candidateUploadData.source,source
                                        )}
                                    </Dropdown.Toggle>
                                    <Dropdown.Menu>
                                        {source.map((source, index) => (
                                            <Dropdown.Item
                                                key={index}
                                                onSelect={(e) => {
                                                    setCandidateUploadData({
                                                        ...candidateUploadData,
                                                        source: e,
                                                    })
                                                }}
                                                value={source.id}
                                                eventKey={source.id}
                                            >
                                                {source.label}
                                            </Dropdown.Item>
                                        ))}
                                    </Dropdown.Menu>
                                </Dropdown>
                            </div>
                        )}
                    </Col>
                    <Col xs={4} className={styles.contentRowRightColumn}>
                        {Object.values(validationErrors).map((error) => (
                            <Alert
                                key={error}
                                variant="danger"
                                onClose={() => setValidationErrors({})}
                                dismissible
                                className="candidate-info-close"
                            >
                                {error}
                            </Alert>
                        ))}
                        <p className={styles.contactText}>Contact</p>
                        <div
                            className={`${styles.indent} ${styles.tabContentText}`}
                        >
                            <p className={styles.urlText}>
                                {((candidate && candidate.email_address) ||
                                    !candidate) && (
                                    <Image
                                        src={MailIcon}
                                        style={{
                                            width: '15px',
                                            height: '15px',
                                            marginRight: '15px',
                                        }}
                                    />
                                )}
                                {(user.role == "recruiter" || user.role == "employer") &&
                                candidate &&
                                !memberOrganization &&
                                candidate.email_address ? (
                                    '*********@' +
                                    candidate.email_address.split('@')[1]
                                ) : candidate ? (
                                    candidate.email_address
                                ) : (
                                    <input
                                        type="email"
                                        placeholder="Email*"
                                        required
                                        className={styles.editInput}
                                        value={
                                            candidate
                                                ? candidate.email_address
                                                : candidateUploadData.emails[0]
                                        }
                                        onChange={(e) => {
                                            handleEmail(e)
                                        }}
                                        onBlur={(e) => {
                                            if (!isEmailValid(e.target.value))
                                                setValidationErrors({
                                                    ...validationErrors,
                                                    error: 'Invalid email format',
                                                })
                                        }}
                                    />
                                )}
                            </p>
                            <p className={styles.urlText}>
                                {((candidate && candidate.phone_number) ||
                                    !candidate) && (
                                    <Image
                                        src={PhoneIcon}
                                        style={{
                                            width: '15px',
                                            height: '15px',
                                            marginRight: '15px',
                                        }}
                                    />
                                )}
                                {(user.role == "recruiter" || user.role == "employer")  &&
                                candidate &&
                                !memberOrganization && 
                                candidate.phone_number ? (
                                    '********' +
                                    candidate.phone_number.toString().substr(-2)
                                ) : candidate ? (
                                    candidate.phone_number
                                ) : (
                                    <input
                                        type="text"
                                        placeholder="(xxx) xxx-xxxx *"
                                        className={`${styles.editInput} ${styles.phonePlaceholder}`}
                                        value={
                                            candidate
                                                ? candidate.phone_number
                                                : candidateUploadData
                                                      .phone_numbers[0]
                                        }
                                        onChange={(e) => handelPhoneNumber(e)}
                                        onBlur={(e) => {
                                            if (!isPhoneValid(e.target.value))
                                                setValidationErrors({
                                                    ...validationErrors,
                                                    error: 'Invalid phone number',
                                                })
                                        }}
                                    />
                                )}
                            </p>
                            {!candidate && <div>{showItems('emails')}</div>}
                            {!candidate && (
                                <div>{showItems('phone_numbers')}</div>
                            )}

                            {candidate && (
                                <div style={{ cursor: 'pointer' }}>
                                    {(allowCandidateUpload || isEditable) && (
                                        <AddButton
                                            title="Add contact info"
                                            controlName="contact_info"
                                            update={
                                                candidate
                                                    ? submitCandidateDataForm
                                                    : addItem
                                            }
                                        />
                                    )}
                                </div>
                            )}
                        </div>
                        <p className={styles.contactText}>Social URL</p>
                        <div
                            className={`${styles.indent} ${styles.tabContentText}`}
                        >
                            <p className={styles.urlText}>
                                {((candidate &&
                                    candidate.linkedin_profile_url) ||
                                    !candidate) && (
                                    <Image
                                        src={LinkedinIcon}
                                        style={{
                                            width: '15px',
                                            height: '15px',
                                            marginRight: '15px',
                                        }}
                                    />
                                )}
                                {candidate && candidate.linkedin_profile_url ? (
                                    <a
                                        href={candidate.linkedin_profile_url}
                                        target="_blank"
                                    >
                                        {candidate && (
                                            <div>
                                                {candidate.linkedin_profile_url}
                                            </div>
                                        )}
                                    </a>
                                ) : (
                                    <>
                                        {candidate === null && (
                                            <input
                                                type="text"
                                                placeholder="Linkedin Profile*"
                                                required
                                                className={styles.editInput}
                                                value={
                                                    candidate
                                                        ? candidate.linkedin_profile_url
                                                        : candidateUploadData
                                                              .linkedin_profile_url[0]
                                                }
                                                onChange={(e) => {
                                                    handleLinkedinUrl(e)
                                                }}
                                                onBlur={(e) => {
                                                    if (
                                                        !isUrlValid(
                                                            e.target.value
                                                        )
                                                    )
                                                        setValidationErrors({
                                                            ...validationErrors,
                                                            error: 'Invalid Linkedin URL format',
                                                        })
                                                }}
                                            />
                                        )}
                                    </>
                                )}
                            </p>
                            {candidate && (allowCandidateUpload || isEditable) && (
                                <div style={{ cursor: 'pointer' }}>
                                    <AddButton
                                        title="linkedin profile url*"
                                        controlName="linkedin_profile_url"
                                        update={
                                            candidate
                                                ? submitCandidateDataForm
                                                : addItem
                                        }
                                    />
                                </div>
                            )}
                        </div>

                        <div
                            className={`${styles.indent} ${styles.tabContentText}`}
                        >
                            <p className={styles.urlText}>
                                {((candidate && candidate.github_url) ||
                                    !candidate) && (
                                    <Image
                                        src={GithubIcon}
                                        style={{
                                            width: '15px',
                                            height: '15px',
                                            marginRight: '15px',
                                        }}
                                    />
                                )}
                                {candidate && candidate.github_url ? (
                                    <a
                                        href={candidate.github_url}
                                        target="_blank"
                                    >
                                        {candidate && (
                                            <div>{candidate.github_url}</div>
                                        )}
                                    </a>
                                ) : (
                                    <>
                                        {candidate === null && (
                                            <input
                                                type="text"
                                                placeholder="Github Profile"
                                                required
                                                className={styles.editInput}
                                                value={
                                                    candidate
                                                        ? candidate.github_url
                                                        : candidateUploadData
                                                              .github_url[0]
                                                }
                                                onChange={(e) => {
                                                    handleGithubUrl(e)
                                                }}
                                                onBlur={(e) => {
                                                    if (
                                                        !isUrlGithubValid(
                                                            e.target.value
                                                        )
                                                    )
                                                        setValidationErrors({
                                                            ...validationErrors,
                                                            error: 'Invalid Github URL format',
                                                        })
                                                }}
                                            />
                                        )}
                                    </>
                                )}
                            </p>
                            {candidate && (allowCandidateUpload || isEditable) && (
                                <div style={{ cursor: 'pointer' }}>
                                    <AddButton
                                        title="github profile url"
                                        controlName="github_url"
                                        update={
                                            candidate
                                                ? submitCandidateDataForm
                                                : addItem
                                        }
                                    />
                                </div>
                            )}
                        </div>

                        <p className={styles.contactText}>Links</p>
                        <div
                            className={`${styles.indent} ${styles.tabContentText}`}
                        >
                            {showItems('links')}

                            <div
                                style={{ cursor: 'pointer', marginTop: '10px' }}
                            >
                                {(isEditable || allowCandidateUpload) && (
                                    <AddButton
                                        title="Add link"
                                        controlName="links"
                                        update={
                                            candidate
                                                ? submitCandidateDataForm
                                                : addItem
                                        }
                                        candidate={candidate}
                                    />
                                )}
                            </div>
                        </div>

                        <p className={styles.contactText}>Resume* <span className={styles.fileType}> (.pdf/.docx)</span></p>
                        <div
                            className={`${styles.indent} ${styles.tabContentText}`}
                        >
                            {resume && (
                                <div className="d-flex">
                                    <Image
                                        src={ResumeIcon}
                                        style={{
                                            width: '15px',
                                            height: '15px',
                                            marginRight: '15px',
                                        }}
                                    ></Image>{' '}
                                    <span
                                        style={{
                                            display: 'inline-block',
                                            width: '150px',
                                        }}
                                        className={styles.urlText}
                                    >
                                        {' '}
                                       
                                        {(currentOrganization.name === "CardinalTalent") ? 
                                        <a href={resumeUrl} download target="_blank">{resume.filename}</a>
                                        : <span>{resume.filename}</span>
                                        }
                                        
                                    </span>
                                    {(allowCandidateUpload || isEditable) && (
                                        <a
                                            onClick={() => {
                                                setResume(null)
                                            }}
                                        >
                                            <i
                                                data-feather="x"
                                                style={{
                                                    width: '10px',
                                                    height: '10px',
                                                    marginLeft: '15px',
                                                    color: 'red',
                                                    cursor: 'pointer',
                                                }}
                                            />
                                        </a>
                                    )}
                                </div>
                            )}
                            {!candidate && <div>{showItems('files')}</div>}
                            <div
                                style={{marginTop: '10px' }}
                            >
                                {(allowCandidateUpload || isEditable) && (
                                    <AddButton
                                        title="Upload file"
                                        controlName="files"
                                        update={
                                            candidate
                                                ? submitCandidateDataForm
                                                : addItem
                                        }
                                    />
                                )}
                            </div>
                        </div>
                        {(isEditable || allowCandidateUpload) && (
                            <Button
                                className={styles.saveButton}
                                onClick={(e) => {
                                    candidate
                                        ? !_.isEqual(
                                              experience,
                                              candidateUploadData.job_experiences
                                          )
                                            ? submitCandidateDataForm(
                                                  e,
                                                  candidateUploadData.job_experiences,
                                                  'experience'
                                              )
                                            : ''
                                        : submitSingleCandidate(e)
                                }}
                            >
                                {candidate
                                    ? 'Update Candidate'
                                    : 'Upload Candidate'}
                            </Button>
                        )}
                    </Col>
                </Row>
            </div>
        )
    } else {
        return null
    }
}

const RecruiterActivityItem = ({ author, created_at, title, content }) => {
    const regExp = /@\[[a-zA-Z\s]+\]/g
    const matches = [...content.matchAll(regExp)].map((arr) => arr[0])

    let val = content

    for (let index = 0; index < matches.length; index++) {
        const element = matches[index]
        val = val.replace(
            element,
            '<b>@' + element.slice(2, element.length - 1) + '</b>'
        )
    }

    return (
        <div className={`${styles.indent} ${styles.tabContentText}`}>
            <Row className="d-flex justify-content-between mx-0">
                <span className={styles.noteAuthorText}>
                    {author ? author.first_name + ' ' + author.last_name : ''}
                </span>
                <span className={styles.noteCreatedText}>
                    {moment(created_at).format('llll')}
                </span>
            </Row>
            <Row className="mx-0">
                <p className={styles.noteCreatedText}>
                    {title ? '@ ' + title : ''}
                </p>
            </Row>
            <Row className="mx-0">
                <p
                    className={styles.noteCreatedText}
                    dangerouslySetInnerHTML={{ __html: val }}
                ></p>
            </Row>
        </div>
    )
}

const AddButton = ({ title, update, controlName, candidate }) => {
    const [isClicked, setIsClicked] = useState(false)
    const [item, setItem] = useState('')
    const [control, setControl] = useState(controlName)
    const [invalidUrl, setInvalidUrl] = useState(null)

    useEffect(() => {
        feather.replace()
    })

    const setSocialState = () => {
        if(control === "linkedin_profile_url"){
            setControl('linkedin_profile_url')
        }
        else if(control === "github_url"){
            setControl('github_url')
        }
    }

    const getHostname = (url) => {
        try {
            return new URL(url).hostname
        } catch (error) {
            setInvalidUrl('Please enter valid url!')
            return null
        }
    }

    const add = (e) => {
        if (e.key === 'Enter' && !e.shiftKey) {
            setInvalidUrl(null)
            if (control === 'links' && !getHostname(item)) {
                setItem('')
                setIsClicked(false)
                return
            }
            if (control === 'emails' && !isEmailValid(item)) {
                setItem('')
                setInvalidUrl('Please enter valid email address!')
                setIsClicked(false)
                return
            }
            if (control === 'phone_numbers' && !isPhoneValid(item)) {
                setItem('')
                setInvalidUrl('Please enter valid phone number!')
                setIsClicked(false)
                return
            }
            if (control === 'linkedin_profile_url' && !isUrlValid(item)) {
                setItem('')
                setInvalidUrl('Please enter valid linkedin url!')
                setIsClicked(false)
                return
            }
            if (control === 'github_url' && !isUrlGithubValid(item)) {
                setItem('')
                setInvalidUrl('Please enter valid github url!')
                setIsClicked(false)
                return
            }
            update(e, item, control)
            setItem('')
            setIsClicked(false)
        }
    }

    if (control === 'skills') {
        return (
            <>
                <input
                    type="text"
                    value={item}
                    autoFocus
                    placeholder="Add Skills"
                    onChange={(e) => setItem(e.target.value)}
                    onKeyDown={add}
                    onBlur={() => {
                        setIsClicked(false)
                        setItem('')
                    }}
                    className={styles.editInput}
                />
                <span className="infoSpan">(Press enter to add skills)</span>
            </>
        )
    }

    if (isClicked) {
        if (control === 'files') {
            return (
                <>
                    <input
                        type="file"
                        value={item}
                        onChange={(e) => {
                            update(e, e.target.files[0], control)
                            setItem('')
                            setIsClicked(false)
                        }}
                        style={{width: '131px', cursor: 'pointer' }}
                        accept=".doc,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document, application/pdf, text/plain, .docx,.txt,.pdf"
                    />
                </>
            )
        }
        if (control == 'contact_info') {
            return (
                <>
                    {isClicked && (
                        <div
                            className={styles.backdrop}
                            onClick={() => setIsClicked(false)}
                        ></div>
                    )}
                    <div className="d-flex align-items-center">
                        <a onClick={setSocialState}>
                            <Image
                                src={PlusIcon}
                                style={{
                                    width: '15px',
                                    height: '15px',
                                    marginRight: '15px',
                                }}
                            />
                        </a>
                        <div className={styles.emailPhonePicker}>
                            <p style={{ cursor: 'pointer' }}>
                                <a onClick={() => setControl('emails')}>
                                    <Image
                                        src={MailIcon}
                                        style={{
                                            width: '15px',
                                            height: '15px',
                                            marginRight: '15px',
                                        }}
                                    />
                                    Email
                                </a>
                            </p>
                            <p style={{ cursor: 'pointer' }}>
                                <a onClick={() => setControl('phone_numbers')}>
                                    <Image
                                        src={PhoneIcon}
                                        style={{
                                            width: '15px',
                                            height: '15px',
                                            marginRight: '15px',
                                        }}
                                    />
                                    Phone number
                                </a>
                            </p>
                        </div>
                    </div>
                </>
            )
        }
        if (control === 'experience') {
            return (
                <textarea
                    type="text"
                    value={item}
                    autoFocus
                    rows={8}
                    onChange={(e) => setItem(e.target.value)}
                    onKeyDown={add}
                    onBlur={() => {
                        setIsClicked(false)
                        setItem('')
                    }}
                    style={{ width: '100%' }}
                />
            )
        }
        return (
            <p className={styles.urlText}>
                {control === 'emails' ? (
                    <Image
                        src={MailIcon}
                        style={{
                            width: '15px',
                            height: '15px',
                            marginRight: '15px',
                        }}
                    />
                ) : control === 'phone_numbers' ? (
                    <Image
                        src={PhoneIcon}
                        style={{
                            width: '15px',
                            height: '15px',
                            marginRight: '15px',
                        }}
                    />
                ) : (
                    control === 'links' && (
                        <Image
                            src={UrlIcon}
                            style={{
                                width: '15px',
                                height: '15px',
                                marginRight: '15px',
                            }}
                        />
                    )
                )}

                <input
                    type="text"
                    value={item}
                    autoFocus
                    onChange={(e) => setItem(e.target.value)}
                    onKeyDown={add}
                    onBlur={() => {
                        setIsClicked(false)
                        setItem('')
                    }}
                    className={styles.editInput}
                />
            </p>
        )
    }

    return (
        <>
            {invalidUrl && (
                <div className={styles.alertMessage}
                >
                    <div className={`${control}` + 'error-class'}>
                    <Alert
                        variant="danger"
                        onClose={() => setInvalidUrl(null)}
                        dismissible
                        className='candidate-info-close'
                    >
                        {invalidUrl}
                    </Alert>
                    </div>
                </div>
            )}
            <div className="d-flex justify-content-between">
                <p style={{ cursor: 'pointer' }}>
                    <a
                        onClick={() => {
                            setIsClicked(true)
                            setControl(controlName)
                        }}
                        className={
                            control === 'skills'
                                ? styles.skillButton
                                : styles.plusButtonText
                        }
                    >
                        {control !== 'skills' && (
                            <Image
                                src={PlusIcon}
                                style={{
                                    width: '15px',
                                    height: '15px',
                                    marginRight: '15px',
                                }}
                            />
                        )}
                        {title}
                    </a>
                </p>
            </div>
        </>
    )
}

const AddNewExperience = (props) => {
    const { onChange, experience, removeExperience, isEditable, allowCandidateUpload } = props 
    useEffect(() => {
        feather.replace()
    })
    
    const handleChange = (e) => {
        onChange({ ...experience, [e.target.name]: e.target.value })
    }

    return (
        <div
            className="d-flex align-items-start"
            style={{ marginBottom: '12px' }}
        >
            <div className="d-flex flex-column w-100">
                <div className="d-flex justify-content-between">
                    <div>
                        <input
                            type="text"
                            name="title"
                            placeholder="Position title"
                            className={styles.editInput}
                            style={{ width: '90px' }}
                            value={experience.title}
                            onChange={handleChange}
                            readOnly={!(isEditable || allowCandidateUpload)}
                        />{' '}
                        &nbsp; <span className={styles.symbolText}>@</span>{' '}
                        &nbsp;
                        <input
                            type="text"
                            name="company_name"
                            placeholder="Company"
                            className={styles.editInput}
                            style={{ width: '80px' }}
                            value={experience.company_name}
                            onChange={handleChange}
                            readOnly={!(isEditable || allowCandidateUpload)}
                        />
                    </div>
                    <div>
                        <input
                            type="text"
                            name="start_date"
                            placeholder="2021-01-25"
                            className={styles.editInput}
                            style={{ width: '70px' }}
                            value={experience.start_date}
                            onChange={handleChange}
                            readOnly={!(isEditable || allowCandidateUpload)}
                        />{' '}
                        -
                        <input
                            type="text"
                            name="end_date"
                            placeholder="Present"
                            className={styles.editInput}
                            style={{ width: '70px' }}
                            value={experience.end_date}
                            onChange={handleChange}
                            readOnly={!(isEditable || allowCandidateUpload)}
                        />
                    </div>
                </div>
                <input
                    type="text"
                    name="location"
                    placeholder="Location"
                    className={styles.editInput}
                    value={experience.location}
                    onChange={handleChange}
                    readOnly={!(isEditable || allowCandidateUpload)}
                />
                <textarea
                    placeholder="Details"
                    name="description"
                    rows="5"
                    style={{ resize: 'none' }}
                    className={styles.editInput}
                    value={experience.description}
                    onChange={handleChange}
                    readOnly={!(isEditable || allowCandidateUpload)}
                />
            </div>
            { (allowCandidateUpload || isEditable) && 
              <div
                className={styles.circleButton}
                style={{
                    background: '#4C68FF',
                    color: '#fff',
                    width: '16px',
                    height: '16px',
                }}
                onClick={() => {
                    removeExperience(experience)
                }}
            >
                <i data-feather="x" />
            </div>
            }
        </div>
    )
}
export default CandidateInfoPanel
