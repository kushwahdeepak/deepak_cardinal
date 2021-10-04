import React, { useState } from 'react'
import { Button, Image } from 'react-bootstrap'
import './styles/TalentPage.scss'
import styles from './styles/TalentPage.module.scss'
import UploadIcon from '../../../../assets/images/talent_page_assets/upload-icon-v2.png'
import GetMatchedImage from '../../../../assets/images/talent_page_assets/get_matched_heading.svg'
import GetMatchedImageAlt from '../../../../assets/images/talent_page_assets/get_matched_heading_alt.svg'
import UploadResumeModal from '../../common/UploadResumeModal/UploadResumeModal'
import UploadResumeSection from '../../common/UploadResumeSection/UploadResumeSection'

const TalentPage = ({ webSocketsUrl, useAltPage }) => {
    const [jobFilterText, setJobFilterText] = useState('')
    const [activePage, setActivePage] = useState(0)
    const [errorFetchingJob, setErrorFetchingJob] = useState(null)
    const [loading, setLoading] = useState(false)
    const [pageCount, setPageCount] = useState(0)
    const [jobs, setJobs] = useState([])
    const [totalJobsCount, setTotalJobsCount] = useState(0)

    return (
        <div className="bg-white">
            <section
                id="pageInfo"
                className="d-flex flex-column align-items-center justify-content-center"
            >
                <Image className="img-fluid"
                    src={useAltPage ? GetMatchedImageAlt : GetMatchedImage}
                />
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
                    render={({
                        showUploadResumeModal,
                        uploadedResume,
                        setShowUploadResumeModal,
                        applyToAllMatches,
                        handleFiles,
                    }) => {
                        return (
                            <>
                                {showUploadResumeModal ? (
                                    <div className="d-flex  justify-content-center">
                                        <UploadResumeModal
                                            uploadedResume={uploadedResume}
                                            handleFiles={handleFiles}
                                            setShowUploadResumeModal={
                                                setShowUploadResumeModal
                                            }
                                        />
                                    </div>
                                ) : (
                                    <div className={styles.uploadResumeBlock}>
                                        <Image src={UploadIcon} fluid />
                                        <div className={styles.buttonGroup}>
                                            <Button
                                                className={styles.applyButton}
                                                style={{
                                                    backgroundColor:
                                                        !uploadedResume
                                                            ? '#304be0'
                                                            : '#fff',
                                                    color: !uploadedResume
                                                        ? '#fff'
                                                        : '#304BE0',
                                                    marginBottom: '10px',
                                                }}
                                                onClick={() =>
                                                    setShowUploadResumeModal(
                                                        true
                                                    )
                                                }
                                            >
                                                Upload Your Resume
                                            </Button>
                                            <Button
                                                className={styles.applyButton}
                                                style={{
                                                    backgroundColor:
                                                        uploadedResume
                                                            ? '#304be0'
                                                            : '#fff',
                                                    color: uploadedResume
                                                        ? '#fff'
                                                        : '#304BE0',
                                                }}
                                                onClick={applyToAllMatches}
                                            >
                                                Apply to All Matches
                                            </Button>
                                        </div>
                                    </div>
                                )}
                            </>
                        )
                    }}
                />
            </section>
        </div>
    )
}

export default TalentPage
