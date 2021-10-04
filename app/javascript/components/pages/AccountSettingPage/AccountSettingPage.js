import React, { useEffect, useState } from 'react'
import { Alert } from 'react-bootstrap'
import styles from './styles/AccountSettingPage.module.scss'
import { capitalize } from '../../../utils'
import {
    Row,
    W3text,
    Column,
    Box,
    Wrapper,
} from './styles/AccountSettingPage.styled'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import EditAccountSetting from './EditAccountSetting'

const AccountSettingPage = (props) => {
    const { currentUser } = props
    const {
        first_name,
        last_name,
        email,
        phone_number,
        active_job_seeker,
        id,
        linkedin_profile_url,
        role,
    } = currentUser
    
    const [isEditBasicInfo, setIsEditBasicInfo] = useState(false)
    const [isEditPreference, setIsEditPreference] = useState(false)
    const [firstName, setFirstName] = useState(first_name)
    const [lastName, setLastName] = useState(last_name)
    const [phoneNumber, setPhoneNumber] = useState(phone_number)
    const [linkedinProfileUrl, setLinkedinId] = useState(linkedin_profile_url)
    const [talentStatus, setTalentStatus] = useState('')

    const talentStatusValue = (activeStatus) => {
        if (activeStatus === 'open_to_new_opportunities')
            return 'No, but I am open to the right opportunity'
        else if (activeStatus === 'active_seeker')
            return 'Yes, I am actively searching for a job'
        else if (activeStatus === 'not_interested')
            return 'No, I am just browsing'
    }
    useEffect(() => {
        const status = talentStatusValue(active_job_seeker)
        setTalentStatus(status)
    }, [active_job_seeker])

    const handleSaveBasic = async (value) => {
        const { firstName, lastName, phoneNumber, linkedinProfileUrl } = value
        const payload = new FormData()
        const url = `/users/${id}`

        payload.append('user[first_name]', firstName)
        payload.append('user[last_name]', lastName)
        payload.append('user[phone_number]', phoneNumber)
        payload.append('user[linkedin_profile_url]', linkedinProfileUrl)
        {
            const response = await makeRequest(url, 'put', payload, {
                contentType: 'application/json',
                loadingMessage: 'Submitting...',
                createSuccessMessage: (response) => response.data.message,
                createResponceMessage: (response) => {
                    return {
                        message: response.message,
                        messageType: 'success',
                        loading: false,
                        autoClose: true,
                    }
                },
                onSuccess: (res) => {
                    setFirstName(res.data.person.first_name)
                    setLinkedinId(res.data.person.linkedin_profile_url)
                    setLastName(res.data.person.last_name)
                    setPhoneNumber(res.data.person.phone_number)
                    setIsEditBasicInfo(!isEditBasicInfo)
                },
            })
        }
    }

    const handleTalentStatus = async () => {
        const payload = new FormData()
        const url = `/users/${id}`
        if(talentStatus !== undefined && talentStatus !== ''){
            payload.append('user[active_job_seeker]', talentStatus)
            const response = await makeRequest(url, 'put', payload, {
                contentType: 'application/json',
                loadingMessage: 'Submitting...',
                createSuccessMessage: (response) => response.data.message,
                createResponseMessage: (response) => {
                    return {
                        message: response.message,
                        messageType: 'success',
                        loading: false,
                        autoClose: true,
                    }
                },
                onSuccess: (res) => {
                    const status = talentStatusValue(
                        res.data.person.active_job_seeker
                    )
                    setTalentStatus(status)
                },
            })
            setIsEditPreference(!isEditPreference)
        }
        else{
            setTalentStatus('')
        }
    }

    // TODO
    // Need a Nav component for account setting page nav

    return (
        <div className="account-setting-page" style={{ display: 'flex' }}>
            <Wrapper className={`${styles.accontSetting}`}>
                <div className={`${styles.sidebar}`}>
                    <div className={`${styles.sidebar_header}`}>
                        <p>{capitalize(`${firstName} ${lastName}`)}</p>
                    </div>
                    <a className={`${styles.active}`} href="/account/setting">
                        General Settings
                    </a>
                    <a href="/account/security">Security & Login</a>
                    <a href="/account/email_verification">Email Verification</a>
                </div>

                <div className={`${styles.containt}`}>
                    <h3>General Settings</h3>
                    <div className={`${styles.basicinfo}`}>
                        <Row>
                            {' '}
                            <h4>Basic Information</h4>
                            {!isEditBasicInfo && (
                                <button
                                    className={`${styles.editButton}`}
                                    onClick={() =>
                                        setIsEditBasicInfo(!isEditBasicInfo)
                                    }
                                >
                                    Edit Basic Information
                                </button>
                            )}
                        </Row>
                        <div className={`${styles.basicinfodetail}`}>
                            {!isEditBasicInfo ? (
                                <>
                                    <Row>
                                        <label>Full Name</label>{' '}
                                        <p className={`${styles.inputWidth}`}>
                                            {capitalize(
                                                `${firstName} ${lastName}`
                                            )}
                                        </p>
                                    </Row>
                                    <Row>
                                        <label>Email</label> <p>{email}</p>
                                    </Row>
                                    {role === 'talent' && (
                                            <>
                                                <Row>
                                                    <label>
                                                        Linkedin profile
                                                    </label>{' '}
                                                    <p>{linkedinProfileUrl}</p>
                                                </Row>
                                            </>
                                        )}
                                    <Row>
                                        <label>Phone Number</label>{' '}
                                        <p>{phoneNumber}</p>
                                    </Row>
                                </>
                            ) : (
                                <EditAccountSetting
                                    handleSaveBasic={handleSaveBasic}
                                    firstName={firstName}
                                    lastName={lastName}
                                    phoneNumber={phoneNumber}
                                    email={email}
                                    linkedinProfileUrl={linkedinProfileUrl}
                                    role={role}
                                    handleSaveBasic={handleSaveBasic}
                                />
                            )}
                        </div>
                    </div>
                    <div className={`${styles.basicinfo}`}>
                        <Row>
                            {' '}
                            <h4>Work Preferences</h4>
                            {!isEditPreference && (
                                <button
                                    className={`${styles.editButton}`}
                                    onClick={() =>
                                        setIsEditPreference(!isEditPreference)
                                    }
                                >
                                    Edit Work Preferences
                                </button>
                            )}
                        </Row>
                        <div className={`${styles.basicinfodetail}`}>
                            <Row>
                                <p>Job Search Status</p>
                            </Row>
                            {!isEditPreference ? (
                                <Row>
                                    <p>{talentStatus}</p>
                                </Row>
                            ) : (
                                <Row>
                                    <Column>
                                        {talentStatus === '' && 
                                        <Alert
                                            variant="danger"
                                            dismissible
                                            className="alert-close"
                                            onClose={() => setTalentStatus(undefined)}
                                        >
                                            Please select job search status before saving.
                                        </Alert>}
                                        <Box>
                                            <input
                                                type="radio"
                                                name="talentStatus"
                                                onChange={() =>
                                                    setTalentStatus(
                                                        'Yes, I am actively searching for a job'
                                                    )
                                                }
                                                checked={
                                                    talentStatus ===
                                                    'Yes, I am actively searching for a job'
                                                }
                                            />
                                            <W3text color="#1D2447" size="14px">
                                                Yes, I am actively searching for
                                                a job
                                            </W3text>
                                        </Box>
                                        <Box>
                                            <input
                                                type="radio"
                                                name="talentStatus"
                                                onChange={() =>
                                                    setTalentStatus(
                                                        'No, but I am open to the right opportunity'
                                                    )
                                                }
                                                checked={
                                                    talentStatus ===
                                                    'No, but I am open to the right opportunity'
                                                }
                                            />
                                            <W3text color="#1D2447" size="14px">
                                                No, but I am open to the right
                                                opportunity
                                            </W3text>
                                        </Box>
                                        <Box>
                                            <input
                                                type="radio"
                                                name="talentStatus"
                                                onChange={() =>
                                                    setTalentStatus(
                                                        'No, I am just browsing'
                                                    )
                                                }
                                                value={talentStatus}
                                                checked={
                                                    talentStatus ===
                                                    'No, I am just browsing'
                                                }
                                            />
                                            <W3text color="#1D2447" size="14px">
                                                No, I am just browsing
                                            </W3text>
                                        </Box>
                                    </Column>
                                    <button
                                        className={`${styles.editButton}`}
                                        onClick={handleTalentStatus}
                                    >
                                        Save Changes
                                    </button>
                                </Row>
                            )}
                        </div>
                    </div>
                </div>
            </Wrapper>
        </div>
    )
}
export default AccountSettingPage
