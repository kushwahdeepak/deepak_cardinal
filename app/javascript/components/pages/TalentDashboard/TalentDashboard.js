import React, { useState } from 'react'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import Button from 'react-bootstrap/Button'
import Image from 'react-bootstrap/Image'
import Nav from 'react-bootstrap/Nav'

import styles from './styles/TalentDashboard.module.scss'
import UploadResumeSection from '../../common/UploadResumeSection/UploadResumeSection'
import UploadResumeModal from '../../common/UploadResumeModal/UploadResumeModal'
import UploadIcon from '../../../../assets/images/talent_page_assets/upload-icon-v3.png'

const TalentDashboard = ({
    currentUser,
    hasResume,
    webSocketsUrl,
    resume,
    applied_jobs_count,
}) => {
    const [jobFilterText, setJobFilterText] = useState('')
    const [activePage, setActivePage] = useState(0)
    const [errorFetchingJob, setErrorFetchingJob] = useState(null)
    const [loading, setLoading] = useState(false)
    const [pageCount, setPageCount] = useState(0)
    const [jobs, setJobs] = useState([])
    const [totalJobsCount, setTotalJobsCount] = useState(0)

    return (
        <div className="bg-white">
            <UploadResumeSection
                webSocketsUrl={webSocketsUrl}
                uploadedResume={resume}
                currentUser={currentUser}
                hasResume={hasResume}
                resume={resume}
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
                    uploadedResume,
                    setUploadedResume,
                    handleFiles,
                    showUploadResumeModal,
                    setShowUploadResumeModal,
                    totalJobsCount,
                }) => {
                    return (
                        <>
                            <UploadApplyControl
                                uploadedResume={uploadedResume}
                                setUploadedResume={setUploadedResume}
                                handleFiles={handleFiles}
                                showUploadResumeModal={showUploadResumeModal}
                                setShowUploadResumeModal={
                                    setShowUploadResumeModal
                                }
                                totalJobsCount={totalJobsCount}
                                applied_jobs_count={applied_jobs_count}
                            />
                        </>
                    )
                }}
            />
        </div>
    )
}

const UploadApplyControl = ({
    uploadedResume,
    setUploadedResume,
    handleFiles,
    showUploadResumeModal,
    setShowUploadResumeModal,
    totalJobsCount,
    applied_jobs_count,
}) => {
    return (
        <div className={styles.container + ' position-relative'}>
            <Row className={styles.newRow}>
                <Col md="6" className={styles.column}>
                    <p className={styles.title}>Resume</p>
                    {uploadedResume ? (
                        <>
                            <Row className="d-flex " >
                                <Col className="styles.imgRow" >
                                    <Image
                                        src={UploadIcon}
                                        style={{
                                            width: '63px',
                                            height: '43px',
                                        }}
                                    />
                                </Col>
                                <Col xs="auto">
                                    <Button
                                        className={styles.button}
                                        onClick={() =>
                                            setShowUploadResumeModal(true)
                                        }
                                    >
                                        Upload New Resume
                                    </Button>
                                    <div
                                        style={{
                                            marginBottom: '23px',
                                            display: 'flex',
                                        }}
                                        className="mt-2 ml-2"
                                    >
                                        <span className={styles.subTitle}>
                                            Uploaded:
                                        </span>{' '}
                                        <span
                                            className={styles.text}
                                            style={{ marginLeft: '13px' }}
                                        >
                                            {uploadedResume.filename ||
                                                uploadedResume.name ||
                                                ''}
                                        </span>
                                        <span
                                            className={styles.text}
                                            style={{ marginLeft: '14px' }}
                                        >
                                            <a
                                                onClick={() =>
                                                    setUploadedResume(null)
                                                }
                                                style={{
                                                    textDecoration: 'none',
                                                    cursor: 'pointer',
                                                }}
                                            >
                                                x
                                            </a>
                                        </span>
                                    </div>
                                </Col>
                            </Row>
                        </>
                    ) : (
                        <>
                            <Row className={`d-flex ${styles.imgRow}`}>
                                <Col xs="auto">
                                    <Image
                                        src={UploadIcon}
                                        style={{
                                            width: '63px',
                                            height: '43px',
                                        }}
                                    />
                                </Col>
                                <Col xs="auto" className="text-center">
                                    <Button
                                        className={styles.button}
                                        onClick={() =>
                                            setShowUploadResumeModal(true)
                                        }
                                    >
                                        Upload Your Resume
                                    </Button>
                                    <p className={styles.subTitle + ' mt-2'}>
                                        To begin matching to jobs
                                    </p>
                                </Col>
                            </Row>
                        </>
                    )}
                </Col>

                <Col md="6" className={styles.columnPadding}>
                    <p className={styles.title}>Applications</p>
                    <span className={styles.subTitle}>You’ve applied to:</span>
                    <div style={{ marginTop: '10px' }}>
                        <Nav.Link href="/submissions/my_submissions" >
                            <span className={styles.text}>
                                    {applied_jobs_count} Jobs
                            </span>
                        </Nav.Link>
                    </div>
                </Col>
            </Row>
            {showUploadResumeModal && (
                <div className={styles.uploadResumeModal}>
                    <UploadResumeModal
                        uploadedResume={uploadedResume}
                        handleFiles={handleFiles}
                        setShowUploadResumeModal={setShowUploadResumeModal}
                    />
                </div>
            )}
        </div>
    )
}

export default TalentDashboard
