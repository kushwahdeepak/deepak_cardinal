import React, { useState } from 'react'
import actionCable from 'actioncable'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import Alert from 'react-bootstrap/Alert'
import Container from 'react-bootstrap/Container'
import axios from 'axios'

import JobResultsTable from '../JobResultsTable/JobResultsTable'

const UploadResumeSection = (props) => {
    const [uploadedResume, setUploadedResume] = useState(props.uploadedResume)
    const [resumeUploadLoading, setResumeUploadLoading] = useState(false)
    const [alertUploadedResume, setAlertUploadedResume] = useState(null)
    const [errorUploadedResume, setErrorUploadedResume] = useState(null)
    const [matchesGenerated, setMatchesGenerated] = useState(false)
    const [showUploadResumeModal, setShowUploadResumeModal] = useState(false)
    const [
        errorApplyForAllMatchingJob,
        setErrorApplyForAllMatchingJob,
    ] = useState(null)
    const [
        alertApplyForAllMatchingJob,
        setAlertApplyForAllMatchingJob,
    ] = useState(null)

    const {
        webSocketsUrl,
        render,
        currentUser,
        hasResume,
        resume,
        jobs,
        setJobs,
        totalJobsCount,
        setTotalJobsCount,
        jobFilterText,
        setJobFilterText,
        activePage,
        setActivePage,
        errorFetchingJob,
        setErrorFetchingJob,
        loading,
        setLoading,
        pageCount,
        setPageCount,
    } = props

    const cableApp = {}
    cableApp.cable = actionCable.createConsumer(webSocketsUrl)

    const applyToAllMatches = () => {
        if (currentUser) {
            applyToAllMatchesUser()
        } else {
            applyToAllMatchesAnon()
        }
    }

    const applyToAllMatchesAnon = () => {
        window.location.href = '/users/sign_in?page=/'
    }

    const applyToAllMatchesUser = async () => {
        const token = document.querySelector('meta[name="csrf-token"]').content
        let headers = {
            'Content-Type': 'Application/json',
            'X-CSRF-Token': token,
        }
        if (hasResume) {
            try {
                const { data } = await axios.post('/match_scores/from_resume', {
                    headers,
                })
                setTopMatchingJobsChannel(data.email)
            } catch (error) {
                setErrorApplyForAllMatchingJob(error.message)
            }
        } else {
            if (uploadedResume) {
                const formData = new FormData()
                formData.append('resume', uploadedResume)
                formData.append('description', 'resume')

                try {
                    const {
                        data,
                    } = await axios.post(
                        '/match_scores/from_resume',
                        formData,
                        { headers }
                    )
                    setTopMatchingJobsChannel(data.email)
                } catch (error) {
                    setErrorApplyForAllMatchingJob(error.message)
                }
            } else {
                setErrorUploadedResume('Upload your resume first!')
            }
        }
    }

    const handleFiles = (files) => {
        const formData = new FormData()
        if (currentUser) {
            formData.append('resume', files[0])
        } else {
            formData.append('file', files[0])
        }
        formData.append('description', 'DA')
        setUploadedResume(files[0])
        sendResume(formData)
        setErrorUploadedResume(null)
        setErrorApplyForAllMatchingJob(null)
    }

    const sendResume = (resume) => {
        const url = currentUser
            ? '/match_scores/from_resume'
            : '/match_scores/from_resume_anon'
        setResumeUploadLoading(true)
        var CSRF_Token = document.querySelector('meta[name="csrf-token"]')
            .content
        const headers = {
            'Content-Type': 'Application/json',
            'X-CSRF-Token': CSRF_Token,
        }

        axios
            .post(url, resume, { headers })
            .then((response) => {
                if (response.data.error) {
                    setErrorUploadedResume(response.data.error)
                    setUploadedResume(null)
                } else {
                    setTopMatchingJobsChannel(response.data.email)
                }
                setResumeUploadLoading(false)
            })
            .catch((error) => {
                setResumeUploadLoading(false)
                setErrorUploadedResume(error.message)
                setUploadedResume(null)
            })
    }

    const setTopMatchingJobsChannel = (email) => {
        cableApp.cable.subscriptions.create(
            {
                channel: 'TopMatchingJobsChannel',
                email: email,
            },
            {
                received: (responseData) => {
                    if (responseData.top_matching_jobs.length > 0) {
                        setJobs(responseData.top_matching_jobs)
                        setTotalJobsCount(responseData.top_matching_jobs.length)
                    } else {
                        setAlertUploadedResume(
                            'There are currently no close matches for your resume. Check back with us before long!'
                        )
                        setJobs([])
                        setTotalJobsCount(responseData.top_matching_jobs.length)
                    }
                    setMatchesGenerated(true)
                    setShowUploadResumeModal(false)
                },
            }
        )
    }

    return (
        <Container style={{ minWidth: '80%' }}>
            <Row className="mt-4">
                <Col>
                    {alertApplyForAllMatchingJob && (
                        <Alert
                            variant="success"
                            onClose={() => setAlertApplyForAllMatchingJob(null)}
                            dismissible
                        >
                            {alertApplyForAllMatchingJob}
                        </Alert>
                    )}
                    {errorApplyForAllMatchingJob && (
                        <Alert
                            variant="danger"
                            onClose={() => setErrorApplyForAllMatchingJob(null)}
                            dismissible
                        >
                            {errorApplyForAllMatchingJob}
                        </Alert>
                    )}
                    {render({
                        showUploadResumeModal,
                        uploadedResume,
                        setUploadedResume,
                        setShowUploadResumeModal,
                        applyToAllMatches,
                        handleFiles,
                        matchesGenerated,
                        totalJobsCount,
                    })}
                </Col>
            </Row>
            <JobResultsTable
                jobs={jobs}
                setJobs={setJobs}
                totalJobsCount={totalJobsCount}
                setTotalJobsCount={setTotalJobsCount}
                matchesGenerated={matchesGenerated}
                setMatchesGenerated={setMatchesGenerated}
                resumeUploadLoading={resumeUploadLoading}
                alertUploadedResume={alertUploadedResume}
                setAlertUploadedResume={setAlertUploadedResume}
                errorUploadedResume={errorUploadedResume}
                setErrorUploadedResume={setErrorUploadedResume}
                jobFilterText={jobFilterText}
                setJobFilterText={setJobFilterText}
                activePage={activePage}
                setActivePage={setActivePage}
                errorFetchingJob={errorFetchingJob}
                setErrorFetchingJob={setErrorFetchingJob}
                loading={loading}
                setLoading={setLoading}
                pageCount={pageCount}
                setPageCount={setPageCount}
            />
        </Container>
    )
}

export default UploadResumeSection
