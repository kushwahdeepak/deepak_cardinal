import React, { Fragment, useState } from 'react'
import { Row, Button, ButtonGroup, Col } from 'react-bootstrap'

import styles from './styles/ScheduledInterviwes.module.scss'
import SearchBar from '../SearchBar/SearchBar'
import ScheduledTable from './ScheduledTable/ScheduledTable'
import Paginator from '../Paginator/Paginator'
import useFetch from '../../hooks/useFetch'
import LeftArrow from '../../../../assets/images/left-arrow.png'
import RightArrow from '../../../../assets/images/right-arrow.png'
import moment from 'moment';

function SheduledInterviwes({ personId ,user, jobs, scheduledInterviewPage}) {
    const [jobFilterText, setJobFilterText] = useState('')
    const [activePage, setActivePage] = useState(0)
    const [pageCount, setPageCount] = useState(0)
    const [month, setMonth] = useState(moment())
    const [monthNumber, setMonthNumber] = useState(moment().format('M'))
    const [search, setSearch] = useState()

    const [isMyInterviwes, setIsMyInterviwes] = useState(true)
    const [
        data,
        loading,
        errorFetchingJob,
        setErrorFetchingJob,
    ] = useFetch(`interview_schedules?show_my_interview_only=${isMyInterviwes}&interviewers_id=${personId}&page=1&month=${monthNumber}&keyword=${jobFilterText}`)
    const handleLeftArrow = () => {
        let monthName = month.subtract(1, "month");
        setMonth(monthName)
        setMonthNumber(month.format("M"))
    }
    
    const handleRightArrow = () => {
        let monthName = month.add(1, "month");
        setMonth(monthName)
        setMonthNumber(month.format("M"))
    }

    const handleSearch = () => {}
    if (loading) {
        return <div>Loading...</div>
    }
    return (
        <Fragment>
            <Row className={`${styles.interviewsRow}`}>
                <Col>
                    <ButtonGroup className={styles.elementButtonGroup}>
                        <Button
                            className={styles.interviwesBtn}
                            style={{
                                background: ` ${
                                    isMyInterviwes
                                        ? 'rgb(76, 104, 255)'
                                        : 'rgb(235, 237, 250)'
                                }`,
                                color: ` ${
                                    isMyInterviwes
                                        ? 'rgb(235, 237, 250)'
                                        : 'rgb(76, 104, 255)'
                                }`,
                                borderRadius: '10px',
                            }}
                            onClick={() => {
                                setIsMyInterviwes(true)
                            }}
                        >
                            My Interviews
                        </Button>
                    { user.role != 'recruiter' ? 
                        <Button
                        className={styles.interviwesBtn}
                        style={{
                            background: ` ${
                                !isMyInterviwes
                                    ? 'rgb(76, 104, 255)'
                                    : 'rgb(235, 237, 250)'
                            }`,
                            color: ` ${
                                !isMyInterviwes
                                    ? 'rgb(235, 237, 250)'
                                    : 'rgb(76, 104, 255)'
                            }`,
                            borderRadius: '10px',
                        }}
                        onClick={() => {
                            setIsMyInterviwes(false)
                        }}
                    >
                        Team’s Interviews
                    </Button>

                    : ''
                    }
                    </ButtonGroup>
                </Col>
                <Col>
                    <div className={`${styles.RightArrowBackground}`} onClick={handleLeftArrow}>
                        <img src={LeftArrow} className={`${styles.RightArrow}`} />
                    </div>
                        <div className={`${styles.monthName}`}>{month.format('MMMM')}</div>
                    <div className={`${styles.LeftArrowBackground}`} onClick={handleRightArrow}>
                        <img src={RightArrow} className={`${styles.LeftArrow}`} />
                    </div>
                </Col>
                <Col>
                    <SearchBar
                        placeholder={'Search by Job title or Candidate name'}
                        value={search}
                        onChange={(e) => {
                            setJobFilterText(e.target.value)
                        }}
                        hideButton={!scheduledInterviewPage}
                    />
                </Col>
                {data.data.length < 0 ?
                    <div className={`${styles.UpcomingText}`}>Upcoming...</div> : ''}
            </Row>
            <Row>
              <Col>
                <ScheduledTable
                    columns={[
                        'candidate',
                        'job-title',
                        'date',
                        'stage-time',
                        'interviewers',
                    ]}
                    activePage={activePage}
                    handlePageChangeClick={setActivePage}
                    totalPages={pageCount}
                    data={data}
                    user={user}
                    jobs={jobs}
                    isMyInterviwes={isMyInterviwes}
                ></ScheduledTable>
              </Col>
            </Row>
            <div className={styles.tableFooter}>
                {pageCount > 0 && (
                    <Paginator
                        pageCount={pageCount}
                        pageWindowSize={5}
                        activePage={activePage}
                        setActivePage={setActivePage}
                    />
                )}
            </div>

        </Fragment>
    )
}

export default SheduledInterviwes
