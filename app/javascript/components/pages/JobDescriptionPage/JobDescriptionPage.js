import React, { useState, useEffect } from 'react'
import { Alert, Spinner, OverlayTrigger, Popover, Modal } from 'react-bootstrap'
import { FacebookShareButton, FacebookIcon, TwitterShareButton,
    TwitterIcon, LinkedinShareButton, LinkedinIcon,} from 'react-share'
import axios from 'axios'
import Moment from 'moment'
import CompanyPlaceholderImage from '../../../../assets/images/talent_page_assets/company-placeholder.png'
import { Row, Container, Button2, Body, ImageContainer,
         Box, HeaderRow, List, Dot, Button, Wrapper, Section,Skill, 
         W4text, W3text, W5text,Header,} from './styles/JobDescriptionPage.styled'
import ReferralModal from '../../common/modals/JobDescriptionModal/ReferralModal'
import { handelBrokenUrl } from '../../common/Utils'
import { skillIsNotEmpty } from '../../../utils'
import CandidateDetails from '../../common/CandidateForm/CandidateDetails'

const popover = (shareUrl) => {
    const content = (
        <Popover id="popover-basic">
            <Popover.Content>
                <FacebookShareButton
                    openShareDialogOnClick={false}
                    onClick={(_, url) => {
                        window.open(url, '_blank')
                    }}
                    style={{ marginLeft: 10 }}
                    url={shareUrl}
                    target="_blank"
                >
                    <FacebookIcon size={32} round />
                </FacebookShareButton>

                <TwitterShareButton
                    openShareDialogOnClick={false}
                    onClick={(_, url) => {
                        window.open(url, '_blank')
                    }}
                    style={{ marginLeft: 10 }}
                    url={shareUrl}
                    target="_blank"
                >
                    <TwitterIcon size={32} round />
                </TwitterShareButton>

                <LinkedinShareButton
                    openShareDialogOnClick={false}
                    onClick={(_, url) => {
                        window.open(url, '_blank')
                    }}
                    style={{ marginLeft: 10 }}
                    url={shareUrl}
                    target="_blank"
                >
                    <LinkedinIcon size={32} round />
                </LinkedinShareButton>
            </Popover.Content>
        </Popover>
    )

    return content
}

const JobDescriptionPage = ({
    jobModel: job,
    currentUser,
    isApplied,
    showInviteFriends,
    appliedDate,
    organizationId,
    goBack,
    jobLocation,
    publicUrl,
    organization,
}) => {
    const {
        name,
        location,
        compensation: salary,
        portalcompanyname: company,
        description,
        niceToHaveSkills,
        skills,
        gen_reqs: requirements,
        pref_skills: preferredSkills,
        logo,
        department,
        experience_years
    } = job
    const [applied, setApplied] = useState(isApplied)
    const [loading, setLoading] = useState(false)
    const [errorCreatingSubmission, setErrorCreatingSubmission] = useState(null)
    const [alertApplyForJob, setAlertApplyForJob] = useState(null)
    const [showReferralModal, setShowReferralModal] =
        useState(showInviteFriends)
    const [joblocation, setJobLocation] = useState(jobLocation)
    const [applyDate, setapplyDate] = useState(appliedDate)
    const [candidateModel, setCandidateModal] = useState(false)
    let prefSkills = skills.length && skills.split(',')
    let niceToHave = niceToHaveSkills?.length && niceToHaveSkills.split(',')
    useEffect(() => {
        setApplied(isApplied)
        setJobLocation(jobLocation)
        setapplyDate(appliedDate)
    }, [isApplied, jobLocation, appliedDate])
    useEffect(() => {
        window.history.pushState(null, document.title, window.location.href)
        window.onpopstate = (event) => goBack(null)
        return function cleanup() {
            window.onpopstate = null
        }
    }, [])

    const handleApply = async () => {
        if (currentUser) {
            const token = document.querySelector(
                'meta[name="csrf-token"]'
            ).content
            let payload = {
                authenticity_token: token,
            }

            payload['submission'] = {
                job_id: job.id,
            }

            try {
                setLoading(true)
                const { data } = await axios.post('/submissions.json', payload)
                if (data.hasOwnProperty('error')) {
                    setErrorCreatingSubmission(data.error)
                    setLoading(false)
                } else {
                    setApplied(true)
                    setapplyDate(new Date())
                    setLoading(false)
                    setAlertApplyForJob(
                        'You successfully applied for this job!'
                    )
                }
            } catch (error) {
                setErrorCreatingSubmission(error.response.data.error)
                setLoading(false)
            }
        } else {
            setCandidateModal(true)
        }
    }

    return (
        <Wrapper>
            <Section flex="1">
                <Header></Header>
            </Section>
            <Section flex="2">
                <Body>
                    <HeaderRow direction="row">
                        <Row direction="row" jContent="flex-end">
                            <ImageContainer>
                                <img
                                    src={logo ? logo : CompanyPlaceholderImage}
                                    onError={(e) => {
                                        handelBrokenUrl(e)
                                    }}
                                />
                            </ImageContainer>
                            <Section
                                direction="row"
                                aSelf="flex-end"
                                mTop="55px"
                            >
                                <Box>
                                    {!currentUser ? (
                                        <Button
                                            lr="35px"
                                            tb="10px"
                                            disabled={applied ? true : false}
                                            onClick={() => handleApply()}
                                        >
                                            <W5text size="12px" color="#ffff">
                                                {!applied
                                                    ? `APPLY FOR THIS JOB`
                                                    : `Applied`}
                                            </W5text>
                                        </Button>
                                    ) : (
                                        <Button
                                            lr="40px"
                                            tb="10px"
                                            disabled={applied ? true : false}
                                            onClick={() => handleApply()}
                                        >
                                            <W5text size="12px" color="#ffff">
                                                {applied
                                                    ? `Applied on ${Moment(
                                                          applyDate
                                                      ).format(
                                                          'DD-MM-YYYY hh:mm:ss'
                                                      )}`
                                                    : 'APPLY FOR THIS JOB'}
                                            </W5text>
                                        </Button>
                                    )}
                                </Box>
                                <Box>
                                    <OverlayTrigger
                                        trigger="click"
                                        placement="top"
                                        overlay={popover(publicUrl)}
                                    >
                                        <Button lr="23px" tb="10px">
                                            <W5text size="12px" color="#ffff">
                                                Share this job
                                            </W5text>
                                        </Button>
                                    </OverlayTrigger>
                                </Box>
                                <Box>
                                    <Button
                                        lr="23px"
                                        tb="10px"
                                        onClick={() => {
                                            !currentUser
                                                ? (window.location =
                                                      '/users/sign_in?page=/&invite_friends=true&job_id=' +
                                                      job.id)
                                                : setShowReferralModal(true)
                                        }}
                                    >
                                        <W5text size="12px" color="#ffff">
                                            Invite to apply
                                        </W5text>
                                    </Button>
                                </Box>
                            </Section>
                        </Row>
                    </HeaderRow>
                    <Row direction="column" style={{ marginBottom: '34px' }}>
                        {alertApplyForJob && (
                            <Alert
                                variant="success"
                                onClose={() => setAlertApplyForJob(null)}
                                dismissible
                            >
                                {alertApplyForJob}
                            </Alert>
                        )}
                        {errorCreatingSubmission && (
                            <Alert
                                variant="danger"
                                onClose={() => setErrorCreatingSubmission(null)}
                                dismissible
                            >
                                {errorCreatingSubmission}
                            </Alert>
                        )}
                        {loading && (
                            <div className="d-flex justify-content-center">
                                <Spinner animation="border" role="status">
                                    <span className="sr-only">Loading...</span>
                                </Spinner>
                            </div>
                        )}
                        <Box>
                            <W4text size="24px" color="#1D2447">
                                <a
                                    href={
                                        organizationId
                                            ? `/organizations/${organizationId}/careers`
                                            : '#'
                                    }
                                >
                                    {organization?.name}
                                </a>
                            </W4text>
                            <Container direction="row">
                            <Box>
                                <Container direction="row">
                                    <List>
                                        {!!department?.length && (
                                            <>
                                                <Dot />
                                                <W4text
                                                    size="20px"
                                                    color="#1D2447"
                                                    style={{marginTop:'2px'}}
                                                >
                                                    {department}
                                                </W4text>
                                            </>
                                        )}
                                    </List>
                                    <List>
                                        {!!location?.length && (
                                            <>
                                                <Dot />
                                                <W4text
                                                    size="20px"
                                                    color="#1D2447"
                                                    style={{marginTop:'2px'}}
                                                >
                                                    {location}
                                                </W4text>
                                            </>
                                        )}
                                    </List>
                                    <List>
                                        {!!experience_years && (
                                            <>
                                                <Dot />
                                                <W4text
                                                    size="20px"
                                                    color="#1D2447"
                                                    style={{marginTop:'2px'}}
                                                >
                                                    {experience_years} Years Experience
                                                </W4text>
                                            </>
                                        )}
                                    </List>
                                </Container>
                            </Box>
                        </Container>
                        </Box>
                        <Box>
                            <W5text size="32px" color="#1D2447">
                                {name}
                            </W5text>
                        </Box>

                        <Container direction="row">
                            {!!requirements?.length && (
                                <Box>
                                    <Button2>{requirements}</Button2>
                                </Box>
                            )}
                            <Box>
                                <Container direction="row">
                                    <List>
                                        {!!joblocation && joblocation.city && (
                                            <>
                                                <Dot />
                                                <W3text
                                                    size="20px"
                                                    color="#1D2447"
                                                >
                                                    {joblocation.city}
                                                </W3text>
                                            </>
                                        )}
                                        {!!joblocation && joblocation.state && (
                                            <>
                                                <W3text
                                                    size="20px"
                                                    color="#1D2447"
                                                >
                                                    {`, ${joblocation.state}`}
                                                </W3text>
                                            </>
                                        )}
                                        {!!joblocation && joblocation.country && (
                                            <>
                                                <W3text
                                                    size="20px"
                                                    color="#1D2447"
                                                >
                                                    {`, ${joblocation.country}`}
                                                </W3text>
                                            </>
                                        )}
                                    </List>
                                    <List>
                                        {!!job?.benefits?.length && (
                                            <>
                                                <Dot />
                                                <W3text
                                                    size="20px"
                                                    color="#1D2447"
                                                >
                                                    {job.benefits}
                                                </W3text>{' '}
                                            </>
                                        )}
                                    </List>
                                    <List>
                                        {!!salary?.length && (
                                            <>
                                                <Dot />
                                                <W3text
                                                    size="20px"
                                                    color="#1D2447"
                                                >
                                                    {salary}
                                                </W3text>{' '}
                                            </>
                                        )}
                                    </List>
                                </Container>
                            </Box>
                        </Container>
                    </Row>

                    <Row direction="row" style={{ paddingRight: '80px' }}>
                        <Section direction="column" flex="4">
                            <Row direction="row">
                                <W5text size="20px" color="#A3AEE8">
                                    About the position
                                </W5text>
                            </Row>
                            <Row direction="row">
                                <div
                                    dangerouslySetInnerHTML={{
                                        __html: description,
                                    }}
                                    style={{ textAlign: `justify`,whiteSpace: 'pre-wrap' }}
                                />
                            </Row>
                        </Section>
                        <Section
                            direction="column"
                            flex="3"
                            style={{ paddingLeft: '75px' }}
                        >
                            <Row direction="column">
                                <Box>
                                    <W5text size="20px" color="#A3AEE8">
                                        Required skills
                                    </W5text>
                                </Box>
                                <Container>
                                    {!!prefSkills &&
                                        prefSkills?.map(
                                            (item, index) =>
                                                skillIsNotEmpty(item) && (
                                                    <Skill key={index}>
                                                        {item}
                                                    </Skill>
                                                )
                                        )}
                                </Container>
                            </Row>
                            <Row direction="column">
                                <Box>
                                    <W5text size="20px" color="#A3AEE8">
                                        Nice to have
                                    </W5text>
                                </Box>
                                <Container>
                                    {!!niceToHave &&
                                        niceToHave.map(
                                            (item, index) =>
                                                skillIsNotEmpty(item) && (
                                                    <Skill key={index}>
                                                        {item}
                                                    </Skill>
                                                )
                                        )}
                                </Container>
                            </Row>
                        </Section>
                    </Row>
                </Body>
                <Row jContent="center" style={{ marginTop: '50px' }}>
                    {!currentUser ? (
                        <Button
                            lr="40px"
                            tb="10px"
                            style={{
                                boxShadow: `0px 4px 15px rgba(0, 0, 0, 0.15)`,
                                marginTop: '105px',
                            }}
                            disabled={applied ? true : false}
                            onClick={() => handleApply()}
                        >
                            <W5text size="12px" color="#ffff">
                                {!applied ? `APPLY FOR THIS JOB` : `Applied`}
                            </W5text>
                        </Button>
                    ) : (
                        <Button
                            lr="40px"
                            tb="10px"
                            disabled={applied ? true : false}
                            style={{marginTop: '105px'}}
                            onClick={() => handleApply()}
                        >
                            <W5text size="12px" color="#ffff">
                                {applied
                                    ? `Applied on ${Moment(
                                          applyDate
                                      ).format(
                                          'DD-MM-YYYY hh:mm:ss'
                                      )}`
                                    : 'APPLY FOR THIS JOB'}
                            </W5text>
                        </Button>
                    )}
                </Row>
            </Section>
            <Modal
                onHide={() => setCandidateModal(false)}
                show={candidateModel}
                size="lg"
                aria-labelledby="contained-modal-title-vcenter"
                centered
                scrollable
            >
                <CandidateDetails
                    job={job}
                    setCandidateModal={setCandidateModal}
                    setErrorCreatingSubmission={setErrorCreatingSubmission}
                    setLoading={setLoading}
                    setApplied={setApplied}
                    setapplyDate={setapplyDate}
                    setAlertApplyForJob={setAlertApplyForJob}
                />
            </Modal>

            <ReferralModal
                job={job}
                show={showReferralModal}
                onHide={() => setShowReferralModal(false)}
                onShow={() => setShowReferralModal(true)}
                setErrorCreatingSubmission={(data) => {
                    setErrorCreatingSubmission(data)
                }}
                setAlertApplyForJob={(data) => {
                    setAlertApplyForJob(data)
                }}
            />
        </Wrapper>
    )
}

export default JobDescriptionPage
