import React, { useEffect, useState } from 'react'
import { Row, Col } from 'react-bootstrap'
import styles from './styles/ScheduledTable.module.scss'
import feather from 'feather-icons'
import { formatDate, formatStage, getAllInterviewers, getAllTimeStage } from '../../Utils'
import ScheduleInterviewDetails from '../../ScheduleInterviewDetails/ScheduleInterviewDetails'
import { makeRequest } from '../../../common/RequestAssist/RequestAssist'

function RenderDeleteTooltip(props) {
    const { setDeletePop, candidate, interview, user } = props
    const endpoint = `/interview_schedules/${interview.id}`

    useEffect(() => {
        feather.replace()
    })

    // Actions 
    const handleCancel = (id) => {
      const url = `/interview_schedules/${id}/cancel`
      makeRequest(url, 'get', '', {})
      .then((res) => {
        setIndex(3)
        window.location.reload();
      });
    }

    const [index, setIndex] = useState(1)

    let interviwe = [
        { key: 'Date', value: formatDate(interview.interview_date), icon: 'calendar' },
        {
            key: 'Interviwes',
            value: getAllInterviewers(interview.interviewers),
            icon: 'briefcase',
        },
        // { key: 'Time', value: '11:00 AM PST', icon: 'clock' },

        // { key: 'Stage', value: formatStage(candidate.interview_type), icon: 'file-text' },

        // { key: 'Time', value: '3:00 AM PST', icon: 'clock' },
        // { key: 'Stage', value: '2nd interview', icon: 'file-text' },
    ]

    interviwe = interviwe.concat(getAllTimeStage(interview.interview_time))

    return (
        <Col className={styles.colWrapper}>
            <Row className={styles.deleteRowHeader}>
                {index === 1 && (
                    <div className={styles.deleteHeader}>
                        Are you sure you want to cancel this interview
                    </div>
                )}
                {index === 3 && (
                    <span className={styles.spanHeaderText}>
                        Your interview has been cancelled
                    </span>
                )}
                {index === 2 && (
                    <span className={styles.spanHeaderText}>
                        Reschedule your interview
                    </span>
                )}

                <div style={{ flexGrow: 1 }}></div>
                <div
                    onClick={() => setDeletePop(null)}
                    className={styles.cancelDelete}
                >
                    <i className={styles.cancelIcon} data-feather="x" />
                </div>
            </Row>
            {index === 1 && (
                <>
                    {' '}
                    <Row className={styles.deleteRowBody}>
                        {interviwe.map((int, index) => (
                            <div
                                key={index}
                                className={styles.iconHeadContainer}
                                style={{ marginBottom: '20px' }}
                            >
                                <div className={styles.deleteIconDiv}>
                                    <i data-feather={`${int.icon}`} />
                                </div>
                                <Col>
                                    <div className={styles.head}>
                                        {int.key}:
                                    </div>
                                    <div className={styles.subHead}>
                                        {int.value}
                                    </div>
                                </Col>
                            </div>
                        ))}
                    </Row>
                    <Row className={styles.deleteRowFooter}>
                        <button
                            className={styles.choicebtn}
                            onClick={() => setIndex(2)}
                        >
                            No, I would like to reschedule
                        </button>
                        <button
                            className={styles.choicebtn}
                            onClick={() => handleCancel(interview.id)}
                        >
                            {' '}
                            Yes, I want to cancel
                        </button>
                    </Row>
                </>
            )}
            {index === 2 && (
                <div className={styles.scheduleInterviewContainer}>
                    <ScheduleInterviewDetails
                        submitText="Save Changes"
                        user={user}
                        candidate={null}
                        interview={interview}
                        url={endpoint}
                        method='put'
                    />
                </div>
            )}
            {index === 3 && (
                <div className={styles.cancelInterviewContainer}>
                    <div className={styles.cancelRow2}>
                        A cancellation email to the candidate will be sent
                        shortly.
                    </div>
                </div>
            )}
        </Col>
    )
}

export default RenderDeleteTooltip
