import React, { useState, useEffect } from 'react'
import axios from 'axios'
import SubmissionResultsBlock from './SubmissionResultsBlock/SubmissionResultsBlock'
import JobDescriptionPage from '../JobDescriptionPage/JobDescriptionPage'

const SubmissionPage = (props) => {
    const [submission, setSubmission] = useState([])
    const [loading, setLoading] = useState(false)
    const [inputValue, setInputValue] = useState('')
    const [activePage, setActivePage] = useState(0)
    const [totalJobsCount, setTotalJobsCount] = useState(0)
    const [totalPages, setTotalPages] = useState(0)
    const [errorSearchingJobs, setErrorSearchingJobs] = useState(null)
    const [currentUser, setCurrentUser] = useState(null)
    const [displayedJob, setDisplayedJob] = useState(null)
    const [isApplied, setIsApplied] = useState(true)
    const [appliedDate, setAppliedDate] = useState(null)
    const [organizationId,setOrganizationId] = useState(null)
    const [jobLocation, setJobLocation] = useState()

    useEffect(() => {
        fetchAppledJobs()
    }, [activePage])

    const submitJobSearch = (event) => {
        event.preventDefault()
        setActivePage(0)
        fetchAppledJobs()
    }

    const handleInputChange = (value) => {
        setInputValue(value)
    }

    const fetchAppledJobs = async () => {
        const url = 'applied_jobs_list'
        setLoading(true)
        const appled_job_search = {
            keyword: inputValue,
        }
        const payload = JSON.stringify({ appled_job_search })
        const CSRF_Token = document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute('content')

        try {
            const response = await axios.post(
                `${url}?page=${activePage + 1}`,
                payload,
                {
                    headers: {
                        'content-type': 'application/json',
                        'X-CSRF-Token': CSRF_Token,
                    },
                }
            )
            const submissionsData = response.data
            const submissions = submissionsData.submissions
            const totalCount = submissionsData.total_count
            const totalPages = submissionsData.total_pages
            setTotalJobsCount(totalCount)
            setTotalPages(totalPages)
            setSubmission(submissions)
        } catch (e) {
            setErrorSearchingJobs(e.message)
        }
        setLoading(false)
    }

    const showJobDetails = async (jobId) => {
        const url = `/jobs/${jobId}.json`
        setLoading(true)

        const CSRF_Token = document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute('content')

        try {
            const response = await axios.get(`${url}`, {
                headers: {
                    'content-type': 'application/json',
                    'X-CSRF-Token': CSRF_Token,
                },
            })

            const jobsData = response.data
            const job = jobsData.job
            const current_user = jobsData.current_user
            const is_applied = jobsData.is_applied
            const publicUrl =  jobsData.public_url
            const applied_date = jobsData.applied_date
            const organizationId = jobsData.organizationId
            const jobLocation =  jobsData.job_location
            setAppliedDate(applied_date)
            setOrganizationId(organizationId)
            setDisplayedJob({...job, ...{ publicUrl }})
            setCurrentUser(current_user)
            setIsApplied(is_applied)
            setJobLocation(jobLocation)
        } catch (e) {
            console.error(e.message)
            setErrorSearchingJobs(e.message)
        }
        setLoading(false)
    }

    return (
        <div className="submission-page">
            <div>
                <>
                    {displayedJob ? (
                        <JobDescriptionPage
                            jobModel={displayedJob}
                            currentUser={currentUser}
                            isApplied={isApplied}
                            goBack={setDisplayedJob}
                            appliedDate={appliedDate}
                            organizationId={organizationId}
                            jobLocation={jobLocation}
                        />
                    ) : (
                        <SubmissionResultsBlock
                            submission={submission}
                            totalJobsCount={totalJobsCount}
                            pageCount={totalPages}
                            activePage={activePage}
                            setActivePage={setActivePage}
                            errorSearchingJobs={errorSearchingJobs}
                            setErrorSearchingJobs={setErrorSearchingJobs}
                            loading={loading}
                            inputValue={inputValue}
                            currentUser={currentUser}
                            showJobDetails={showJobDetails}
                            submitJobSearch={submitJobSearch}
                            handleInputChange={handleInputChange}
                        />
                    )}
                </>
            </div>
        </div>
    )
}

export default SubmissionPage
