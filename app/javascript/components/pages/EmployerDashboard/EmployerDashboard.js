import React, { useState, useEffect } from 'react'
import { Alert, Spinner } from 'react-bootstrap'
import axios from 'axios'
import feather from 'feather-icons'

import styles from './styles/EmployerDashboard.module.scss'
import Paginator from '../../common/Paginator/Paginator'
import Header from './Header/Header'
import JobsTable from './Table/JobsTable'
import NoOrganization from './NoOrganization'

const RESULTS_PER_PAGE = 25

const EmployerDashboard = ({ userId, organization, currentUser }) => {
    const [jobs, setJobs] = useState([])
    const [totalJobsCount, setTotalJobsCount] = useState(0)
    const [activePage, setActivePage] = useState(0)
    const [totalPages, setTotalPages] = useState(0)
    const [errorFetchingJob, setErrorFetchingJob] = useState(null)
    const [loading, setLoading] = useState(false)
    const [jobFilterText, setJobFilterText] = useState('')
    const [showMyJobs, setShowMyJobs] = useState(true)
    const [showMyClosedJobs, setShowMyClosedJobs] = useState(false)
    const [reloadData, setReloaddata] = useState(false)
    const [openEmailSequenceModal, setOpenEmailSequenceModal] = useState(false)

    useEffect(() => {
      setLoading(true)
      if (jobFilterText.length > 0) {
        handleSearch()
      }
      else {
        axios
          .get(
            `/employer_home.json?page=${activePage + 1
            }&show_my_jobs=${showMyJobs}&show_my_closed_jobs=${showMyClosedJobs}`
          )
          .then((res) => {
            setJobs(res.data.jobs)
            setTotalJobsCount(res.data.jobsCount)
            setLoading(false)
            setTotalPages(res.data.total_pages)
          })
          .catch((err) => {
            setErrorFetchingJob(err.message)
            setLoading(false)
          })
      }
    }, [activePage, showMyJobs, showMyClosedJobs, reloadData])

    useEffect(() => {
        feather.replace()
    })
    const handleSearch = async () => {
        const url = 'job_searches/search'
        setLoading(true)
        const job_search = { job_keyword: jobFilterText }
        const payload = JSON.stringify({ job_search })
        const CSRF_Token = document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute('content')

        try {
            // TODO: add show_my_jobs value according selected tab
            // My Jobs  : show_my_jobs = true
            // All Jobs : show_my_jobs = false
            const response = await axios.post(
                `${url}?page=${activePage + 1}&show_my_jobs=${showMyJobs}&show_my_closed_jobs=${showMyClosedJobs}`,
                payload,
                {
                    headers: {
                        'content-type': 'application/json',
                        'X-CSRF-Token': CSRF_Token,
                    },
                }
            )

            const jobsData = response.data
            const jobs = jobsData.jobs
            const totalCount = jobsData.total_count
            const totalPages = jobsData.total_pages
            setTotalJobsCount(totalCount)
            setErrorFetchingJob(null)
            setJobs(jobs)
            setTotalPages(totalPages)
        } catch (e) {
            console.error(e.message)
            setErrorFetchingJob(e.message)
        }
        setLoading(false)
    }

    const handleMyJobs = () => {
        setActivePage(0)
        setJobs([])
        setShowMyJobs(true)
    }

    const handleAllJobs = () => {
        setActivePage(0)
        setJobs([])
        setShowMyJobs(false)
        setShowMyClosedJobs(false)
    }

    const handleClosedJobs = () =>{
        setJobs([])
        setShowMyJobs(false)
        setShowMyClosedJobs(false)
    }
    if (!organization) return <NoOrganization/>
    else
    return (
        <div className={styles.container}>
            <Header
                handleMyJobs={handleMyJobs}
                handleAllJobs={handleAllJobs}
                handleClosedJobs={handleClosedJobs}
                setShowMyClosedJobs={setShowMyClosedJobs}
                setJobFilterText={setJobFilterText}
                setActivePage={setActivePage}
                handleSearch={handleSearch}
                showMyJobs={showMyJobs}
                showMyClosedJobs={showMyClosedJobs}
                jobFilterText={jobFilterText}
                loading={loading}
                organization={organization}
                currentUser={currentUser}
                setReloaddata={setReloaddata}
                reloadData={reloadData}
                setOpenEmailSequenceModal={setOpenEmailSequenceModal}
                openEmailSequenceModal={openEmailSequenceModal}
            />
            {loading ? (
                <div className="d-flex justify-content-center">
                    <Spinner animation="border" role="status">
                        <span className="sr-only">Loading...</span>
                    </Spinner>
                </div>
            ) : errorFetchingJob ? (
                <Alert
                    variant="danger"
                    onClose={() => setErrorFetchingJob(null)}
                    dismissible
                    className="mt-4 newAlert"
                >
                    {errorFetchingJob}
                </Alert>
            ) : (
                <>
                    <JobsTable jobs={jobs} userId={userId} />
                    <div
                        style={{
                            marginTop: '32px',
                            display: 'flex',
                            justifyContent: 'center',
                        }}
                    >
                        {totalPages > 1 && (
                            <Paginator
                                pageCount={totalPages}
                                pageWindowSize={5}
                                activePage={activePage}
                                setActivePage={setActivePage}
                            />
                        )}
                    </div>
                </>
            )}
        </div>
    )
}

export default EmployerDashboard
