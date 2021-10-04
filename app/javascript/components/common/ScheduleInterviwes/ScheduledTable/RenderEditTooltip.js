import React, { useEffect, useState } from 'react'
import { Row, Col, OverlayTrigger } from 'react-bootstrap'
import styles from './styles/ScheduledTable.module.scss'
import feather from 'feather-icons'
import Form from 'react-bootstrap/Form'
import { formatDate, formatStage, getAllInterviewers, getAllTimeStage } from '../../Utils'
import ScheduleInterviewDetails from '../../ScheduleInterviewDetails/ScheduleInterviewDetails'

function RenderEditTooltip(props) {
    const { setEditPop, candidate, interview, user, jobs } = props
    const [feedback, setFeedback] = useState()
    const [addFeedback, setAddFeedback] = useState(false)
    const [isEdit, setIsEdit] = useState(false)
    // const endpoint = `/interview_schedules/${interview.id}`

    let interviwe = [
        { key: 'Date', value: formatDate(interview?.interview_date? interview?.interview_date : ''), icon: 'calendar' },
        {
            key: 'Interviwes',
            value: getAllInterviewers(interview.interviewers? interview.interviewers : ''),
            icon: 'briefcase',
        },
        // { key: 'Time', value: '11:00 AM PST', icon: 'clock' },
        // { key: 'Stage', value: formatStage(candidate.interview_type), icon: 'file-text' },

        // { key: 'Time', value: '3:00 AM PST', icon: 'clock' },
        // { key: 'Stage', value: '2nd interview', icon: 'file-text' },
    ]

    interviwe = interviwe.concat(getAllTimeStage(interview.interview_time? interview.interview_time : ''))


    useEffect(() => {
        feather.replace()
    })
    const handleAddFeedback = () => {
        setAddFeedback(!addFeedback)
    }
    const handleOnSubmit = () => {
        setAddFeedback(!addFeedback)
    }

    const renderFeedback = (props) => (
        <div className={styles.addFeedBackContainer} {...props}>
            <Row className={styles.feedbackRow}>
                <span className={styles.feedbackHeader}>
                    {' '}
                    Add Feedback for John Smith{' '}
                </span>
            </Row>
            <Row className={styles.feedbackRow}>
                <span className={styles.feedbackSubHeader}>
                    Interview Details:
                </span>
            </Row>
            <Row className={styles.feedbackRow}>
                <div className={styles.feedbackDate}>
                    Monday March 1, 2020 11:30 AM PST (Recruiter screen)
                    <div className={styles.feedbackIcon}>
                        <svg
                            width="5"
                            height="4"
                            viewBox="0 0 5 4"
                            fill="none"
                            xmlns="http://www.w3.org/2000/svg"
                        >
                            <path
                                d="M2.5 4L4.66506 0.25H0.334936L2.5 4Z"
                                fill="#4C68FF"
                            />
                        </svg>
                    </div>
                </div>
            </Row>
            <div className={styles.feedbackRowInput}>
                <Form.Control
                    as="textarea"
                    rows="3"
                    value={feedback}
                    className={styles.feedbackTextarea}
                    onChange={(e) => setFeedback(e.target.value)}
                    placeholder="This feedback will only be viewable to you and any
                other interviewers added"
                />
            </div>
            <Row
                className={styles.feedbackRow}
                style={{ justifyContent: 'flex-end', marginTop: '4px' }}
            >
                <button onClick={handleOnSubmit} className={styles.fbSubmitBtn}>
                    Submit
                </button>
            </Row>
        </div>
    )

    return (
        <Col className={styles.colWrapper}>
            {!isEdit ? (
                <>
                    <Row className={styles.editHead}>
                        <div
                            className={styles.deleteHeader}
                            style={{ marginLeft: '5px', marginBottom: '0px' }}
                        >
                            Interview Details
                        </div>
                        <OverlayTrigger
                            show={addFeedback}
                            placement="bottom"
                            delay={{ show: 250, hide: 400 }}
                            overlay={renderFeedback}
                        >
                            <button
                                className={styles.choicebtn}
                                style={{ marginLeft: '40px' }}
                                onClick={handleAddFeedback}
                            >
                                Add Feedback
                            </button>
                        </OverlayTrigger>
                        <div className={styles.iconContainer}>
                            <button onClick={() => setIsEdit(!isEdit)}>
                                {' '}
                                <i
                                    data-feather="edit-2"
                                    style={{ marginRight: '23px' }}
                                />
                            </button>
                            <button>
                                {' '}
                                <i data-feather="trash-2" />
                            </button>
                        </div>
                        <div style={{ flexGrow: 1 }}></div>
                        <div
                            onClick={() => setEditPop(null)}
                            className={styles.cancelDelete}
                        >
                            <i className={styles.cancelIcon} data-feather="x" />
                        </div>
                    </Row>

                    <Col className={styles.editItemContainer}>
                        {interviwe.map((inter, index) => (
                            <div key={index} className={styles.infoContainer}>
                                <div
                                    className={styles.iconHeadContainer}
                                    style={{ marginBottom: '20px' }}
                                >
                                    <div className={styles.deleteIconDiv}>
                                        <i data-feather={`${inter.icon}`} />
                                    </div>
                                    <Col>
                                        <div className={styles.head}>
                                            {inter.key}:
                                        </div>
                                        <div className={styles.subHead}>
                                            {inter.value}
                                        </div>
                                    </Col>
                                </div>
                            </div>
                        ))}
                    </Col>
                </>
            ) : (
                <div className={styles.editScheduleInterviewContainer}>
                    <Row className={styles.editScheduleHead}>
                        <div
                            className={styles.deleteHeader}
                            style={{ marginLeft: '40px', marginBottom: '0px' }}
                        >
                            Edit interview details
                        </div>
                        <div style={{ flexGrow: 1 }}></div>
                        <div
                            onClick={() => setEditPop(null)}
                            className={styles.cancelDelete}
                        >
                            <i className={styles.cancelIcon} data-feather="x" />
                        </div>
                    </Row>

                    {/* <Row className={styles.scheduleInterviewContainer}>
                        <ScheduleInterviewDetails
                            submitText="Save Changes"
                            user={user}
                            candidate={null}
                            interview={interview}
                            url={endpoint}
                            method='put'
                            jobs={jobs}
                        />
                    </Row> */}
                </div>
            )}
        </Col>
    )
}

export default RenderEditTooltip
