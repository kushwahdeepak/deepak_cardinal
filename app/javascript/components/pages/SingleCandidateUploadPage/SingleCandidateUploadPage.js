import React, { useState } from 'react'

import UploadResumeSection from '../../common/UploadResumeSection/UploadResumeSection'
import DragAndDrop from '../../common/DragAndDrop/DragAndDrop'

const SingleCandidateUploadPage = ({ webSocketsUrl }) => {
    const [jobFilterText, setJobFilterText] = useState('')
    const [activePage, setActivePage] = useState(0)
    const [errorFetchingJob, setErrorFetchingJob] = useState(null)
    const [loading, setLoading] = useState(false)
    const [pageCount, setPageCount] = useState(0)
    const [jobs, setJobs] = useState([])
    const [totalJobsCount, setTotalJobsCount] = useState(0)

    return (
        <section className="d-flex flex-column align-items-center justify-content-center">
            <UploadResumeSection
                webSocketsUrl={webSocketsUrl}
                jobs={jobs}
                setJobs={setJobs}
                totalJobsCount={totalJobsCount}
                setTotalJobsCount={setTotalJobsCount}
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
                render={({ handleFiles }) => {
                    return (
                        <>
                            <DragAndDrop handleFiles={handleFiles} />
                        </>
                    )
                }}
            />
        </section>
    )
}

export default SingleCandidateUploadPage
