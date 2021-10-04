import React, { useState, useEffect } from 'react'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'

import Spinner from 'react-bootstrap/Spinner'
import Alert from 'react-bootstrap/Alert'
import axios from 'axios'

import styles from './styles/JobResultsTable.module.scss'
import JobPositionCard from '../JobPositionCard/JobPositionCard'
import SearchBar from '../SearchBar/SearchBar'
import Paginator from '../Paginator/Paginator'
import HorizontalLoader from '../../common/HorizontalLoader/HorizontalLoader'
import Util from '../../../utils/util'

const JobResultsTable = (props) => {
    const {
        jobs,
        setJobs,
        totalJobsCount,
        setTotalJobsCount,
        alertUploadedResume,
        setAlertUploadedResume,
        matchesGenerated,
        setMatchesGenerated,
        resumeUploadLoading,
        errorUploadedResume,
        setErrorUploadedResume,
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

    useEffect(() => {
        handleSearch()
    }, [activePage])

    const handleSearch = async () => {
        setAlertUploadedResume(null)
        setErrorUploadedResume(null)
        setMatchesGenerated(false)
        const url = 'job_searches/search'
        setLoading(true)
        const job_search = {
            keyword: jobFilterText,
        }
        const payload = JSON.stringify({ job_search })
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

            const jobsData = response.data
            const jobs = jobsData.jobs
            const total_count = jobsData.total_count
            const totalPages = jobsData.total_pages

            setJobs(jobs)
            setTotalJobsCount(total_count)
            setPageCount(totalPages)
            setLoading(false)
        } catch (error) {
            setErrorFetchingJob(error.message)
            setLoading(false)
        }
    }

    const displayNumberOfResults = () => {
        if (totalJobsCount < 1) return
        if (matchesGenerated) return `1 - ${totalJobsCount} of ${totalJobsCount}`
        return Util.displayNumberOfResults(
            totalJobsCount,
            pageCount,
            activePage,
            10
        )
    }

    return (
        <div
            className="d-flex flex-column align-items-center"
            style={{ marginBottom: '50px', width: '100%' }}
        >
            <div className={styles.container}>
                <Row className={styles.titleRow}>
                    <Col xl={4}>
                        <p className={styles.recommendedJobsTitle}>
                            <span>
                                {matchesGenerated
                                    ? 'AI Matched Jobs'
                                    : 'Recommended Jobs'}
                            </span>
                            <span
                                className="ml-3"
                                style={{ fontSize: '0.75rem' }}
                            >
                                {displayNumberOfResults()}
                            </span>
                        </p>
                    </Col>
                    <Col xl={6}>
                        <SearchBar
                            placeholder={
                                'Search by Job title, keyword, or company'
                            }
                            value={jobFilterText}
                            onChange={(e) => setJobFilterText(e.target.value)}
                            onEnterPressed={(event) => {
                                setActivePage(0)
                                handleSearch()
                            }}
                            onButtonClick={handleSearch}
                        ></SearchBar>
                    </Col>
                </Row>
                {loading ? (
                    <div className="d-flex justify-content-center">
                        <Spinner animation="border" role="status">
                            <span className="sr-only">Loading...</span>
                        </Spinner>
                    </div>
                ) : resumeUploadLoading ? (
                    <div className="d-flex flex-column justify-content-center align-items-center">
                        <p className={styles.alertText}>
                            Please give us a moment as our AI generates your
                            matches!
                        </p>
                        <HorizontalLoader />
                    </div>
                ) : alertUploadedResume ? (
                    <div>{alertUploadedResume}</div>
                ) : errorUploadedResume ? (
                    <div className="text-danger">{errorUploadedResume}</div>
                ) : errorFetchingJob ? (
                    <Alert
                        variant="danger"
                        onClose={() => setErrorFetchingJob(null)}
                        dismissible
                    >
                        {errorFetchingJob}
                    </Alert>
                ) : (
                    <>
                        {jobs.length == 0 && <div>No jobs to display</div>}
                        {jobs.map((job) => (
                            <JobPositionCard
                                key={job.id}
                                job={job}
                                matchScore={job.score}
                                showSalary={false}
                            />
                        ))}
                    </>
                )}
            </div>
            { !matchesGenerated && pageCount > 2 &&
                <Paginator
                    pageCount={pageCount}
                    activePage={activePage}
                    setActivePage={setActivePage}
                    pageWindowSize={5}
                />
            }
        </div>
    )
}

export default JobResultsTable
