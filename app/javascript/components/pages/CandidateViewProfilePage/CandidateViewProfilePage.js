import React, { useEffect, useContext, useReducer, useState } from 'react'
import Button from 'react-bootstrap/Button'
import Image from 'react-bootstrap/Image'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import styles from './styles/CandidateViewProfilePage.module.scss'
import CandidateTwoImage from '../../../../assets/images/img_avatar.png'
import moment from 'moment'
import { capitalize, stringReplace } from '../../../utils'
import feather from 'feather-icons'
import Modal from '../../common/Styled components/Modal'
import EditCandidateProfile from './EditCandidateProfile'
import styled from 'styled-components'
import { reducer, UserProfileContext } from '../../../stores/UserProfileStore'

const Link = styled.div`
    display: flex;
    align-items: center;
    cursor: pointer;
    > svg {
        margin-right: 10px;
        margin-bottom: 2px;
    }
`

const CandidateViewProfilePage = (props) => {
    const [open, setOpen] = useState(false)
    const { currentUser, person, avatar_url, experiences, skills } = props
    const { first_name, last_name, description, title, school, location,employer } =
        person
    let initialState = {
        ...initialState,
        ...{
            currentUser,
            person,
            first_name,
            last_name,
            description,
            title,
            school,
            employer,
            location,
            skills,
            avatar_url,
            experiences,
            deleteExperienceId: [],
            skillset: '',
        },
    }
    const [state, dispatch] = useReducer(reducer, initialState)

    useEffect(() => {
        feather.replace()
    })

    const format_logo_url = (avatar_url) => {
        if (typeof avatar_url == 'object') {
            return URL.createObjectURL(avatar_url)
        }
        return avatar_url
    }

    return (
        <UserProfileContext.Provider value={{ state, dispatch }}>
            <div className="candidate-view-profile-page">
                <div
                    className={`${styles.profileHeading} jumbotron jumbotron-fluid`}
                >
                    <div className="container"></div>
                </div>
                <div className="container">
                    <div className={`${styles.profileImageSection}`}>
                        <Row>
                            <Col xs={12} sm={12} md={6} lg={6}>
                                <Image
                                    src={
                                        state.avatar_url == null ||
                                        state.avatar_url == ''
                                            ? CandidateTwoImage
                                            : format_logo_url(state.avatar_url)
                                    }
                                    className={`${styles.profileImage}`}
                                />
                            </Col>
                            <Col xs={12} sm={12} md={6} lg={6}>
                                <button
                                    className={`${styles.editProfileButton}`}
                                    onClick={() => setOpen(!open)}
                                >
                                    Edit Profile
                                </button>
                                <Modal
                                    isOpen={open}
                                    s
                                    onBlur={() => setOpen(!open)}
                                >
                                    <EditCandidateProfile
                                        open={open}
                                        setOpen={setOpen}
                                        format_logo_url={format_logo_url}
                                    />
                                </Modal>
                            </Col>
                        </Row>
                    </div>
                    <Row>
                        <Col xs={12}>
                            <h2 className={`${styles.profileName} mt-2`}>
                                {capitalize(
                                    `${(state.first_name != null && state.first_name != 'null') ? state.first_name :''} ${(state.last_name != null && state.last_name != 'null') ? state.last_name : ''}`
                                )}
                            </h2>
                        </Col>
                        <Col
                            xs={12}
                            className={`${styles.profileheading} d-flex`}
                        >
                            <Headline experiences={experiences} />
                        </Col>
                    </Row>
                    <Row className="mt-5">
                        <Col xs={12} sm={12} md={4} lg={4} className="mb-5">
                            <div className={`${styles.profileAboutme}`}>
                                <h4 className={`${styles.profileHeadingTitle}`}>
                                    About Me
                                </h4>
                                <AboutMe
                                    setOpen={setOpen}
                                    open={open}
                                    description={ ((state.description != null && state.description != 'null') ? state.description : '' ) || ''}
                                />
                            </div>
                            <div className={`${styles.profileSkills} mt-5`}>
                                <h4 className={`${styles.profileHeadingTitle}`}>
                                    Skills
                                </h4>
                                <Skills
                                    setOpen={setOpen}
                                    open={open}
                                    skills={skills}
                                />
                            </div>
                        </Col>
                        <Col xs={12} sm={12} md={8} lg={8}>
                            <h4 className={`${styles.profileHeadingTitle}`}>
                                Experience
                            </h4>
                            <Experiences
                                setOpen={setOpen}
                                open={open}
                                experiences={props.experiences}
                            />
                        </Col>
                    </Row>
                </div>
            </div>
        </UserProfileContext.Provider>
    )
}

function Headline({ experiences }) {
    if (experiences.length == 0) return ''
    const { title, company_name, location, school } = experiences[0]
    return (
        <>
            <span>{title}</span>
            {!!company_name && (
                <>
                    <div className={`${styles.profileheadingseprate}`}></div>
                    <span>{company_name}</span>
                </>
            )}
            {!!location && (
                <>
                    <div className={`${styles.profileheadingseprate}`}></div>
                    <span>{location}</span>
                </>
            )}
            {!!school && (
                <>
                    <div className={`${styles.profileheadingseprate}`}></div>
                    <span>{school || '-'}</span>
                </>
            )}
        </>
    )
}

function Skills({ skills, setOpen, open }) {
    if (skills.length == 0)
        return (
            <Link onClick={() => setOpen(!open)}>
                <i data-feather="plus-circle" width="14px" height="14px"></i>
                <a>Add Skills</a>
            </Link>
        )
    return (
        <>
            {skills.map((skill, index) => (
                <span key={index}>
                    {capitalize(stringReplace(skill, '_', ' '))}
                </span>
            ))}
        </>
    )
}

function Experiences({ experiences, setOpen, open }) {
    if (experiences.length == 0)
        return (
            <Link onClick={() => setOpen(!open)}>
                <i data-feather="plus-circle" width="14px" height="14px"></i>
                <a>Add Experience</a>
            </Link>
        )

    return (
        <>
            {experiences.map((experience, index) => (
                <div className={`${styles.experienc}`} key={index}>
                    <h5 className={`${styles.experienceHeader}`}>
                        {experience.title}{' '}
                        {(experience.title && experience.company_name) ?? (
                            <>@</>
                        )}{' '}
                        {/* {experience.company_name} */}
                    </h5>
                    <h6 className={`${styles.experienceDate}`}>
                        {ExperienceDate(experience?.start_date)} {(ExperienceDate(experience?.start_date) === ' ') ? '' : '-'}
                        {experience.present == true
                            ? 'Present'
                            : ExperienceDate(experience?.end_date)}
                    </h6>
                    <div className="clearfix"></div>
                    <h6 className={`${styles.experienceDetail}`}>
                        {experience.location}
                    </h6>
                    {experience.description ?? (
                        <ul>
                            {experience.description
                                .split('\n')
                                .map((description, index) => (
                                    <li key={index}>{description}</li>
                                ))}
                        </ul>
                    )}
                </div>
            ))}
        </>
    )
}

function AboutMe({ description, setOpen, open }) {
    if (description == '')
        return (
            <Link onClick={() => setOpen(!open)}>
                <i data-feather="plus-circle" width="14px" height="14px"></i>
                <a>Add Description</a>
            </Link>
        )
    return (
        <>
            <div
                className={`${styles.profileDetail}`}
                dangerouslySetInnerHTML={{ __html: description }}
            />
        </>
    )
}

function ExperienceDate(date) {
    if (!date || date == '') return ' '
    return moment(date).format('MMM YYYY')
}

export default CandidateViewProfilePage
