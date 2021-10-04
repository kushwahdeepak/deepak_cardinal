import React, { useEffect, useState } from 'react'
import feather from 'feather-icons'
import Col from 'react-bootstrap/Col'
import Row from 'react-bootstrap/Row'
import Alert from 'react-bootstrap/Alert'
import Button from 'react-bootstrap/Button'
import Dropdown from 'react-bootstrap/Dropdown'
import Tab from 'react-bootstrap/Tab'
import Nav from 'react-bootstrap/Nav'
import Image from 'react-bootstrap/Image'
import axios from 'axios'
import moment from 'moment'
import { nanoid } from 'nanoid'

import styles from './styles/CandidateInfoPanel.module.scss'
import ResumeIcon from '../../../../assets/images/icons/resume-icon.svg'
import GithubIcon from '../../../../assets/images/icons/github-icon.svg'
import LinkedinIcon from '../../../../assets/images/icons/linkedin-icon.svg'
import UploadIcon from '../../../../assets/images/icons/upload-icon.svg'
import UrlIcon from '../../../../assets/images/icons/url-link-icon.svg'
import AddNote from '../AddNote/AddNote'
import { makeRequest, RequestAssist } from '../RequestAssist/RequestAssist'

function CandidateUploadPanel({ candidate, closeFunc, dispatch, state, show }) {
    const [notes, setNotes] = useState([])
    const [candidateSubmited, setCandidateSubmited] = useState(false)
    const [errorFetchingCandidate, setErrorFetchingCandidate] = useState(null)
    const [resume, setResume] = useState(null)
    const [noteAdded, setNoteAdded] = useState(false)
    const [requestAssistProps, setRequestAssistProps] = useState({})
    const [showPanel, setShowPanel] = useState()
    const [candidateUploadData, setCandidateUploadData] = useState({
        name: '',
        title: '',
        company: '',
        location: '',
        school: '',
        experiences: [],
        skills: [],
        emails: [],
        phone_numbers: [],
        links: [],
        files: [],
    })
    const [email, setEmail] = useState('')
    const [phoneNumber, setPhoneNumber] = useState('')
    const [linkedinUrl, setLinkedinUrl] = useState('')
    const [githubUrl, setGithubUrl] = useState('')

    useEffect(() => {
        if (candidate) setShowPanel(true)
        else setShowPanel(show)
    }, [show, candidate])

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
            axios
                .get(`/people/${candidate.id}.json`)
                .then((res) => {
                    setSubmissions(res.data.submissions)
                    setJobs(res.data.jobs)
                    setCurrentUser(res.data.currentUser)
                    setCurrentOrganization(res.data.currentOrganization)
                    setNotes(res.data.notes)
                    setResume(res.data.resume)
                })
                .catch((e) => {
                    errorFetchingCandidate && (
                        <Alert
                            variant="danger"
                            onClose={() => setErrorFetchingCandidate(null)}
                            dismissible
                        >
                            {errorFetchingCandidate}
                        </Alert>
                    )
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
        if (Array.isArray(skills) && skills.length) {
            return skills
        } else if (typeof skills === 'string' && skills.length) {
            return skills.split(',') ?? []
        }
        return []
    }

    const close = () => {
        if (candidate) closeFunc()
        else setShowPanel(false)
    }

    const displaySkills = (skills) => {
        if (!skills) return null
        return formatSkills(skills).map((skill, index) => (
            <div className={styles.skillBadge} key={`${index} ${skill}`}>
                {skill}
            </div>
        ))
    }

    const showNextCandidate = (currentlyDisplayedCandidate) => {
        const currentCandidateIndex = state.candidates.indexOf(
            currentlyDisplayedCandidate
        )
        const nextIndex =
            currentCandidateIndex + 1 >= state.candidates.length
                ? state.candidates.length - 1
                : currentCandidateIndex + 1

        dispatch({
            type: 'show_candidate',
            candidate: state.candidates[nextIndex],
        })
    }

    const showPrevCandidate = (currentlyDisplayedCandidate) => {
        const currentCandidateIndex = state.candidates.indexOf(
            currentlyDisplayedCandidate
        )
        const nextIndex =
            currentCandidateIndex - 1 < 0 ? 0 : currentCandidateIndex - 1

        dispatch({
            type: 'show_candidate',
            candidate: state.candidates[nextIndex],
        })
    }

    const submitCandidateDataForm = async (event, item, controlName) => {
        const modifiedCandidate = { ...candidate }

        event.preventDefault()
        const url = `/people/${candidate.id}.json`
        const formData = new FormData()

        switch (controlName) {
            case 'experience':
                modifiedCandidate.company_names =
                    modifiedCandidate.company_names.length > 0
                        ? modifiedCandidate.company_names.concat('\n', item)
                        : item
                break
            case 'skills':
                modifiedCandidate.skills =
                    modifiedCandidate.skills.length > 0
                        ? modifiedCandidate.skills.concat(',', item)
                        : item
                break
            case 'phone_numbers':
                modifiedCandidate.phone_number = item
                break
            case 'emails':
                modifiedCandidate.email_address = item
                break
            case 'linkedin_url':
                modifiedCandidate.linkedin_profile_url = item
                break
            case 'github_url':
                modifiedCandidate.github_url = item
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
        formData.append(
            'person[linkedin_profile_url]',
            modifiedCandidate.linkedin_profile_url || ''
        )
        formData.append(
            'person[github_url]',
            modifiedCandidate.github_url || ''
        )

        formData.append('person[first_name]', modifiedCandidate.first_name)
        formData.append('person[last_name]', modifiedCandidate.last_name)
        formData.append('person[school]', modifiedCandidate.school)

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

    const showExperienceForm = () => {
        const newExperience = {
            id: nanoid(),
            title: '',
            company_name: '',
            location: '',
            start_date: '',
            end_date: new Date(),
            description: '',
        }

        setCandidateUploadData({
            ...candidateUploadData,
            experiences: [...candidateUploadData.experiences, newExperience],
        })
    }

    const addNewExperience = (exp) => {
        setCandidateUploadData({
            ...candidateUploadData,
            experiences: candidateUploadData.experiences.map((e) => {
                if (e.id === exp.id) return exp
                else return e
            }),
        })
    }

    const removeExperience = (exp) => {
        setCandidateUploadData({
            ...candidateUploadData,
            experiences: candidateUploadData.experiences.filter(
                (e) => e.id != exp.id
            ),
        })
    }

    const addItem = (e, item, control) => {
        setCandidateUploadData({
            ...candidateUploadData,
            [control]: [...candidateUploadData[control], item],
        })
    }

    const removeItem = (item, control) => {
        setCandidateUploadData({
            ...candidateUploadData,
            [control]: candidateUploadData[control].filter((e) => e != item),
        })
    }

    const handleChange = (e) => {
        setCandidateUploadData({
            ...candidateUploadData,
            [e.target.name]: e.target.value,
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
                        <i
                            data-feather="mail"
                            style={{
                                width: '10px',
                                height: '10px',
                                marginRight: '15px',
                            }}
                        ></i>
                    )
                    break
                case 'phone_numbers':
                    icon = (
                        <i
                            data-feather="phone"
                            style={{
                                width: '10px',
                                height: '10px',
                                marginRight: '15px',
                            }}
                        ></i>
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
                                width: '20px',
                                height: '20px',
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
                                width: '20px',
                                height: '20px',
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
                {candidateUploadData[control].map((e, idx) => (
                    <p
                        key={idx}
                        className={styles.urlText}
                        onClick={() => removeItem(e, control)}
                    >
                        {getIcon(e)}
                        <span>{control === 'files' ? e.name : e}</span>
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
                    </p>
                ))}
            </>
        )
    }

    const submitCandidate = async () => {
        const data = { ...candidateUploadData }
        const url = `/people/new/single_candidate`
        const formData = new FormData()
        formData.append('person[company_names]' , data.company)
        formData.append('person[skills]'        , data.skills)
        formData.append('person[phone_number]'  , data.phone_numbers)
        formData.append('person[email_address]' , data.emails)
        formData.append('person[github_url]'    , data.github_url || '')
        formData.append('person[first_name]'    , data.name.split(' ')[0] )
        formData.append('person[last_name]'     , data.name.split(' ')[1])
        formData.append('person[school]'        , data.school)
        formData.append('person[job_experience]', JSON.stringify(data.experiences))
        formData.append('person[linkedin_profile_url]', data.linkedin_profile_url || '')

        const response = await makeRequest(url, 'post', formData, {
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
        })
    }

    if (!showPanel) return null

    return (
        <div className={styles.infoPanel}>
            <Row className="d-flex justify-content-between">
                <Col xs={8} className="d-flex position-relative w-100">
                    {candidate ? (
                        <>
                            <Button className={styles.topRowButton}>
                                Schedule
                            </Button>
                            <Button className={styles.topRowButton}>
                                Contact
                            </Button>
                            {window.location.pathname !=
                                '/people_searches/new' && (
                                <Dropdown>
                                    <Dropdown.Toggle
                                        className={styles.topRowButton}
                                        id="dropdown-basic"
                                    >
                                        Move Stage
                                    </Dropdown.Toggle>

                                    <Dropdown.Menu>
                                        <Dropdown.Item>Applicant</Dropdown.Item>
                                        <Dropdown.Item>
                                            First Interview
                                        </Dropdown.Item>
                                        <Dropdown.Item>
                                            Second Interview
                                        </Dropdown.Item>
                                        <Dropdown.Item>Offer</Dropdown.Item>
                                        <Dropdown.Item>Reject</Dropdown.Item>
                                    </Dropdown.Menu>
                                </Dropdown>
                            )}

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
                            >
                                <i data-feather="chevron-left" />
                            </div>
                            <div
                                className={styles.circleButton}
                                onClick={() => showNextCandidate(candidate)}
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
                        <i data-feather="x" />
                    </div>
                </Col>
            </Row>
            <Row className={styles.contentRow}>
                <Col xs={8} className={styles.contentRowLefColumn}>
                    {candidate ? (
                        <>
                            <p className={styles.nameText}>
                                {candidate.first_name} {candidate.last_name}
                            </p>
                            <p className={styles.personalInfoText}>
                                {candidate.title || ''}
                            </p>
                            <p className={styles.personalInfoText}>
                                {candidate.location || ''}
                            </p>
                            <p className={styles.personalInfoText}>
                                {candidate.school || ''}
                            </p>
                        </>
                    ) : (
                        <>
                            <input
                                type="text"
                                name="name"
                                placeholder="Candidate name"
                                className={`${styles.editInput} ${styles.editCandidateName}`}
                                value={candidateUploadData.name}
                                onChange={handleChange}
                            />
                            <div className="d-flex align-items-center">
                                <input
                                    type="text"
                                    name="title"
                                    placeholder="Position title"
                                    className={styles.editInput}
                                    value={candidateUploadData.title}
                                    onChange={handleChange}
                                />
                                &nbsp;{' '}
                                <span className={styles.symbolText}>@</span>{' '}
                                &nbsp;
                                <input
                                    type="text"
                                    name="company"
                                    placeholder="Current company"
                                    className={styles.editInput}
                                    value={candidateUploadData.company}
                                    onChange={handleChange}
                                />
                            </div>
                            <div>
                                <input
                                    type="text"
                                    name="location"
                                    placeholder="Location"
                                    className={styles.editInput}
                                    value={candidateUploadData.location}
                                    onChange={handleChange}
                                />
                            </div>
                            <div>
                                <input
                                    type="text"
                                    name="school"
                                    placeholder="University"
                                    className={styles.editInput}
                                    value={candidateUploadData.school}
                                    onChange={handleChange}
                                />
                            </div>
                            <Button className={styles.uploadButton}>
                                <Image
                                    src={UploadIcon}
                                    width={10}
                                    height={10}
                                />{' '}
                                <span style={{ marginLeft: '10px' }}>
                                    Upload Resume
                                </span>
                            </Button>
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
                            <Tab.Content style={{ width: '100%' }}>
                                <Tab.Pane eventKey="about_candidate">
                                    <p className={styles.tabContentTitle}>
                                        EXPERIENCE
                                    </p>
                                    {candidate && (
                                        <p
                                            className={`${styles.indent} ${styles.tabContentText}`}
                                        >
                                            {candidate.company_names}
                                        </p>
                                    )}

                                    <div
                                        className={`${styles.indent} ${styles.tabContentText}`}
                                        style={{ cursor: 'pointer' }}
                                    >
                                        {candidateUploadData.experiences.map(
                                            (exp) => (
                                                <AddNewExperience
                                                    key={exp.id}
                                                    experience={exp}
                                                    onChange={addNewExperience}
                                                    removeExperience={
                                                        removeExperience
                                                    }
                                                />
                                            )
                                        )}
                                        {candidate && (
                                            <AddButton
                                                title="Add experience"
                                                controlName="experience"
                                                update={submitCandidateDataForm}
                                            />
                                        )}
                                        {!candidate && (
                                            <div className="d-flex justify-content-between align-items-center">
                                                <p
                                                    style={{
                                                        cursor: 'pointer',
                                                    }}
                                                >
                                                    <a
                                                        onClick={() =>
                                                            showExperienceForm()
                                                        }
                                                    >
                                                        <i
                                                            data-feather="plus"
                                                            style={{
                                                                width: '10px',
                                                                height: '10px',
                                                                marginRight:
                                                                    '10px',
                                                            }}
                                                        />{' '}
                                                        Add experience
                                                    </a>
                                                </p>
                                                <Button
                                                    className={
                                                        styles.saveButton
                                                    }

                                                    onClick={(CandidateUploadData) => submitCandidate({...CandidateUploadData})}
                                                >
                                                    Save
                                                </Button>
                                            </div>
                                        )}
                                    </div>
                                    <p className={styles.tabContentTitle}>
                                        SKILLS
                                    </p>

                                    <div
                                        className={`${styles.indent} mb-3 d-flex skillscontent flex-wrap`}
                                    >
                                        {displaySkills(
                                            candidate
                                                ? candidate.skills
                                                : candidateUploadData.skills
                                        )}
                                    </div>

                                    <div
                                        className={`${styles.indent} ${styles.tabContentText}`}
                                        style={{ cursor: 'pointer' }}
                                    >
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
                                                    created_at={note.created_at}
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
                            </Tab.Content>
                        </Row>
                    </Tab.Container>
                </Col>
                <Col xs={4} className={styles.contentRowRightColumn}>
                    <p className={styles.contactText}>CONTACT</p>
                    <div
                        className={`${styles.indent} ${styles.tabContentText}`}
                    >
                        <p className={styles.urlText}>
                            <i
                                data-feather="mail"
                                style={{
                                    width: '10px',
                                    height: '10px',
                                    marginRight: '15px',
                                }}
                            ></i>{' '}
                            {candidate ? (
                                candidate.email_address
                            ) : (
                                <input
                                    type="text"
                                    placeholder="Email"
                                    className={styles.editInput}
                                    value={email}
                                    onChange={(e) => setEmail(e.target.value)}
                                />
                            )}
                        </p>
                        <p className={styles.urlText}>
                            <i
                                data-feather="phone"
                                style={{
                                    width: '10px',
                                    height: '10px',
                                    marginRight: '15px',
                                }}
                            ></i>{' '}
                            {candidate ? (
                                candidate.phone_number
                            ) : (
                                <input
                                    type="text"
                                    placeholder="Phone number"
                                    className={styles.editInput}
                                    value={phoneNumber}
                                    onChange={(e) =>
                                        setPhoneNumber(e.target.value)
                                    }
                                />
                            )}
                        </p>

                        {!candidate && <div>{showItems('emails')}</div>}
                        {!candidate && <div>{showItems('phone_numbers')}</div>}

                        <div style={{ cursor: 'pointer' }}>
                            <AddButton
                                title="Add contact info"
                                controlName="contact_info"
                                update={
                                    candidate
                                        ? submitCandidateDataForm
                                        : addItem
                                }
                            />
                        </div>
                    </div>
                    <p className={styles.contactText}>LINKS</p>
                    <div
                        className={`${styles.indent} ${styles.tabContentText}`}
                    >
                        <p className={styles.urlText}>
                            <Image
                                src={LinkedinIcon}
                                style={{
                                    width: '20px',
                                    height: '20px',
                                    marginRight: '15px',
                                }}
                            />

                            {candidate ? (
                                candidate.linkedin_profile_url
                            ) : (
                                <input
                                    type="text"
                                    placeholder="Linkedin URL"
                                    className={styles.editInput}
                                    value={linkedinUrl}
                                    onChange={(e) =>
                                        setLinkedinUrl(e.target.value)
                                    }
                                />
                            )}
                        </p>

                        <p className={styles.urlText}>
                            <Image
                                src={GithubIcon}
                                style={{
                                    width: '20px',
                                    height: '20px',
                                    marginRight: '15px',
                                }}
                            />

                            {candidate ? (
                                candidate.github_url
                            ) : (
                                <input
                                    type="text"
                                    placeholder="Github URL"
                                    className={styles.editInput}
                                    value={githubUrl}
                                    onChange={(e) =>
                                        setGithubUrl(e.target.value)
                                    }
                                />
                            )}
                        </p>

                        {!candidate && <div>{showItems('links')}</div>}

                        <div style={{ cursor: 'pointer' }}>
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
                        </div>
                    </div>
                    <p className={styles.contactText}>FILES</p>
                    <div
                        className={`${styles.indent} ${styles.tabContentText}`}
                    >
                        {resume && (
                            <p className={styles.urlText}>
                                <Image
                                    src={ResumeIcon}
                                    style={{
                                        width: '20px',
                                        height: '20px',
                                        marginRight: '15px',
                                    }}
                                ></Image>{' '}
                                {resume.filename}
                            </p>
                        )}
                        {!candidate && <div>{showItems('files')}</div>}
                        <div style={{ cursor: 'pointer' }}>
                            <AddButton
                                title="Upload file"
                                controlName="files"
                                update={
                                    candidate
                                        ? submitCandidateDataForm
                                        : addItem
                                }
                            />
                        </div>
                    </div>
                </Col>
            </Row>
        </div>
    )
}

const RecruiterActivityItem = ({ author, created_at, title, content }) => {
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
                <p className={styles.noteCreatedText}>{content || ''}</p>
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
            if (control === 'links') {
                const hostname = getHostname(item)
                if (hostname === 'github.com' && candidate) {
                    update(e, item, 'github_url')
                } else if (hostname === 'linkedin.com' && candidate) {
                    update(e, item, 'linkedin_url')
                } else if (!candidate && hostname != null) {
                    update(e, item, control)
                }
            } else {
                update(e, item, control)
            }
            setItem('')
            setIsClicked(false)
        }
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
                        style={{ width: '100%' }}
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
                    <div className={styles.emailPhonePicker}>
                        <p style={{ cursor: 'pointer' }}>
                            <a onClick={() => setControl('emails')}>
                                <i
                                    data-feather="mail"
                                    style={{
                                        width: '10px',
                                        height: '10px',
                                        marginRight: '15px',
                                    }}
                                />{' '}
                                Email
                            </a>
                        </p>
                        <p style={{ cursor: 'pointer' }}>
                            <a onClick={() => setControl('phone_numbers')}>
                                <i
                                    data-feather="phone"
                                    style={{
                                        width: '10px',
                                        height: '10px',
                                        marginRight: '15px',
                                    }}
                                />{' '}
                                Phone number
                            </a>
                        </p>
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
                    <i
                        data-feather="mail"
                        style={{
                            width: '10px',
                            height: '10px',
                            marginRight: '15px',
                        }}
                    ></i>
                ) : control === 'phone_numbers' ? (
                    <i
                        data-feather="phone"
                        style={{
                            width: '10px',
                            height: '10px',
                            marginRight: '15px',
                        }}
                    ></i>
                ) : (
                    !candidate &&
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
                <Alert
                    variant="danger"
                    onClose={() => setInvalidUrl(null)}
                    dismissible
                    className={styles.alert}
                >
                    {invalidUrl}
                </Alert>
            )}
            <div className="d-flex justify-content-between">
                <p style={{ cursor: 'pointer' }}>
                    <a
                        onClick={() => {
                            setIsClicked(true)
                            setControl(controlName)
                        }}
                        className={
                            control === 'skills' ? styles.skillButton : ''
                        }
                    >
                        {control !== 'skills' && (
                            <i
                                data-feather="plus"
                                style={{
                                    width: '10px',
                                    height: '10px',
                                    marginRight: '10px',
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
    useEffect(() => {
        feather.replace()
    })

    const handleChange = (e) => {
        props.onChange({ ...props.experience, [e.target.name]: e.target.value })
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
                            value={props.experience.title}
                            onChange={handleChange}
                        />{' '}
                        &nbsp; <span className={styles.symbolText}>@</span>{' '}
                        &nbsp;
                        <input
                            type="text"
                            name="company_name"
                            placeholder="Company"
                            className={styles.editInput}
                            style={{ width: '80px' }}
                            value={props.experience.company_name}
                            onChange={handleChange}
                        />
                    </div>
                    <div>
                        <input
                            type="text"
                            name="start_date"
                            placeholder="01/2020"
                            className={styles.editInput}
                            style={{ width: '70px' }}
                            value={props.experience.start_date}
                            onChange={handleChange}
                        />{' '}
                        -
                        <input
                            type="text"
                            name="end_date"
                            placeholder="Present"
                            className={styles.editInput}
                            style={{ width: '70px' }}
                            value={props.experience.end_date}
                            onChange={handleChange}
                        />
                    </div>
                </div>
                <input
                    type="text"
                    name="location"
                    placeholder="Location"
                    className={styles.editInput}
                    value={props.experience.location}
                    onChange={handleChange}
                />
                <textarea
                    placeholder="Details"
                    name="description"
                    rows="5"
                    style={{ resize: 'none' }}
                    className={styles.editInput}
                    value={props.experience.description}
                    onChange={handleChange}
                />
            </div>
            <div
                className={styles.circleButton}
                style={{
                    background: '#4C68FF',
                    color: '#fff',
                    width: '16px',
                    height: '16px',
                }}
                onClick={() => {
                    props.removeExperience(props.experience)
                }}
            >
                <i data-feather="x" />
            </div>
        </div>
    )
}

export default CandidateUploadPanel
