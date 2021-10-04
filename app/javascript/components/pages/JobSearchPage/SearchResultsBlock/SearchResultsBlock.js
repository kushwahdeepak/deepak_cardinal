import React from 'react'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import FormControl from 'react-bootstrap/FormControl'
import Image from 'react-bootstrap/Image'
import Button from 'react-bootstrap/Button'
import Spinner from 'react-bootstrap/Spinner'
import Alert from 'react-bootstrap/Alert'

import styles from './SearchResultsBlock.module.scss'
import SearchIcon from '../../../../../assets/images/talent_page_assets/search-icon.png'
import JobPositionCard from '../../../common/JobPositionCard/JobPositionCard'
import Paginator from '../../../common/Paginator/Paginator'
import Util from '../../../../utils/util'
import JobSearchBar from '../../../common/JobSearchBar/JobSearchBar'
import FilterJob from '../../../FilterJob'

const SearchResultsBlock = (props) => {
    const {
        jobs,
        loading,
        activePage,
        totalJobsCount,
        pageCount,
        submitJobSearch,
        handleInputChange,
        inputValue,
        setActivePage,
        setErrorSearchingJobs,
        errorSearchingJobs,
        filterStack,
        setStackFilter,
        handleSearch,
        experienceYears,
        setExperienceYears,
        user,
    } = props
    const displayNumberOfResults = () => {
        return Util.displayNumberOfResults(
            totalJobsCount,
            pageCount,
            activePage,
            6
        )
    }

    const displayText = `Displaying ${displayNumberOfResults()} results`

    return (
        <div>
            <div className={`${styles.jobSearchHeading}`}>
                <div className="container text-center">
                    <h2>Search for jobs</h2>
                    <p>
                        Browse thousands of actively hiring positions from top
                        companies
                    </p>
                </div>
                <JobSearchBar
                    placeholder="Search by Job title, keyword, or company"
                    value={inputValue}
                    onChange={(e) => handleInputChange(e.target.value)}
                    onEnterPressed={(e) => {
                        setActivePage(0)
                        submitJobSearch(e)
                    }}
                />
            </div>
            <div className={styles.mainSearchblock} fluid>
                <div className={styles.containers}>
                    {window.location.pathname == "/cardinal_jobs" ?  
                        "" :
                        <div className={`${styles.filterJob} `}>
                            <FilterJob
                                filterStack={filterStack}
                                setStackFilter={setStackFilter}
                                handleSearch={handleSearch}
                                experienceYears={experienceYears}
                                setExperienceYears={setExperienceYears}
                            />
                        </div> 
                    }
                    {loading ? (
                        <div
                            className="d-flex justify-content-center align-items-center align-content-center"
                            style={{ width: '72%' }}
                        >
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
                        <Col>
                            <div className={styles.tableColumn}>
                                <div className="search-results-wrap__bottom-row">
                                    {jobs && jobs.length ? (
                                        jobs.map((jobItem) => {
                                            return (
                                                <JobPositionCard
                                                    key={jobItem.id}
                                                    job={jobItem}
                                                    matchScore={jobItem.score}
                                                    showSalary={false}
                                                    showLocation={false}
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

                            {Array.isArray(jobs) && pageCount > 1 && (
                                <Row className="d-flex justify-content-center">
                                    <Paginator
                                        pageCount={pageCount}
                                        pageWindowSize={5}
                                        activePage={activePage}
                                        setActivePage={setActivePage}
                                    />
                                </Row>
                            )}
                        </Col>
                    )}
                </div>
            </div>
        </div>
    )
}

export default SearchResultsBlock
