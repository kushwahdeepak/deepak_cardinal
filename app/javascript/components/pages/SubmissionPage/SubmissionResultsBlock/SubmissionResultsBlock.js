import React from 'react'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import FormControl from 'react-bootstrap/FormControl'
import Image from 'react-bootstrap/Image'
import Button from 'react-bootstrap/Button'
import Spinner from 'react-bootstrap/Spinner'
import Alert from 'react-bootstrap/Alert'
import styles from './styles/SubmissionResultsBlock.module.scss'
import SearchIcon from '../../../../../assets/images/talent_page_assets/search-icon.png'
import JobAppledCard from '../../../common/JobAppledCard/JobAppledCard'
import Paginator from '../../../common/Paginator/Paginator'
import Util from '../../../../utils/util'
import JobSearchBar from '../../../common/JobSearchBar/JobSearchBar'
import FilterJob from "../../../FilterJob";

const SubmissionResultsBlock = (props) => {
    const {
        submission,
        totalJobsCount,
        pageCount,
        activePage,
        setErrorSearchingJobs,
        errorSearchingJobs,
        loading,
        inputValue,
        currentUser,
        setActivePage,
        showJobDetails,
        submitJobSearch,
        handleInputChange
    } = props

    const displayNumberOfResults = () => {
        return Util.displayNumberOfResults(
            totalJobsCount,
            pageCount,
            activePage,
            10
        )
    }
    const displayText = `Displaying ${displayNumberOfResults()} results`

    return (
        <div>
            <div className={`${styles.jobSearchHeading}`}>
                <div className="container text-center">
                        <h2>My Applied Jobs</h2>
                </div>
                <JobSearchBar
                    placeholder="Search by Job title, keyword, or company"
                    value={inputValue}
                    onChange={(e) =>
                        handleInputChange(e.target.value)
                    }
                    onEnterPressed={(e) => {
                        setActivePage(0)
                        submitJobSearch(e)
                    }}
                />
            </div>
            <div className={styles.containers}>
                <Row>
                    {loading ? (
                                <div className="d-flex justify-content-center align-items-center align-content-center" style={{margin:'0px auto'}}>
                                    <Spinner animation="border" role="status">
                                        <span className="sr-only">Loading...</span>
                                    </Spinner>
                                </div>
                            ) : errorSearchingJobs ? (
                                <Alert
                                    variant="danger"
                                    onClose={() => setErrorSearchingJobs(null)}
                                    dismissible
                                >
                                    {errorSearchingJobs}
                                </Alert>
                            ) : (
                    <Col lg='12' md='12' sm='12' xs='12'>
                        <div>
                            <div className={`${styles.paginationText}`}>{displayText}</div>
                            <div className="submission-results-wrap__bottom-row">
                                {submission && submission?.length ? (
                                    submission?.map((jobItem) => {
                                        return (
                                            <JobAppledCard
                                                key={jobItem.id}
                                                submission={jobItem}
                                                job={jobItem.job}
                                                organization={jobItem.job.organization}
                                                showJobDetails={showJobDetails}
                                            />
                                        )
                                    })
                                ) : (
                                    <div style={{ textAlign: 'center' }}>
                                        No jobs found
                                    </div>
                                )}
                            </div>
                        </div>

                        {Array.isArray(submission) && pageCount > 1 && (
                            <Row className="d-flex justify-content-center">
                                <Paginator
                                    pageCount={pageCount}
                                    pageWindowSize={10}
                                    activePage={activePage}
                                    setActivePage={setActivePage}
                                    showJobDetails={showJobDetails}
                                />
                            </Row>
                        )}
                    </Col>)}
                </Row>
            </div>
        </div>
    )
}

export default SubmissionResultsBlock
