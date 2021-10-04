import React, { useState, useEffect, useRef, useContext } from 'react'
import Modal from 'react-bootstrap/Modal'
import styles from './styles/ScheduleModal.module.scss'
import feather from 'feather-icons'
import { nanoid } from 'nanoid'
import './styles/ScheduleModal.scss'
import { Image } from 'react-bootstrap'
import Form from 'react-bootstrap/Form'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import { makeRequest } from '../RequestAssist/RequestAssist'
import CalendarIcon from '../../../../assets/images/icons/calendar-icon.svg'
import ClockIcon from '../../../../assets/images/icons/clock-icon.svg'
import ResumeIcon from '../../../../assets/images/icons/resume-icon.svg'
import WorkIcon from '../../../../assets/images/icons/work-icon.svg'
import { StoreDispatchContext } from '../../../stores/JDPStore'
import moment from 'moment'
import ScheduleInterviewDetails from '../ScheduleInterviewDetails/ScheduleInterviewDetails'

function ScheduleModel({ show, onHide, user, jobs , onInterview, fullJob }) {
    const [showSummary, setShowSummary] = useState(false)
    const { dispatch, state } = useContext(StoreDispatchContext)
    const [openModal, setOpenModal] = useState(true)
    const candidate = state.scheduleModalData.candidate
    const endpoint = '/interview_schedules'
    
    useEffect(() => {
        feather.replace()
    })

    return (
        <Modal
            className="scheduleModal"
            show={show}
            onHide={onHide}
            aria-labelledby="contained-modal-title-vcenter"
            backdropClassName={styles.modalBackdrop}
            size="xl"
            centered
        >
            <Modal.Body className={styles.modalBody}>
                <div className={styles.titleSection}>
                    {showSummary ? (
                        <div className="d-flex flex-column">
                            <p>Your interview has been scheduled!</p>
                            <span>A confirmation email will be sent soon.</span>
                        </div>
                    ) : (
                        'Schedule an interview'
                    )}
                    <button
                        className={styles.closeButton}
                        onClick={(e) => {
                            onHide()
                        }}
                    >
                        <i data-feather="x" width="15px" height="15px"></i>
                    </button>
                </div>

                {!showSummary && (
                    <>
                        <ScheduleInterviewDetails
                            submitText="Send invitation for interview"
                            user={user}
                            candidate={candidate}
                            interview={null}
                            url={endpoint}
                            hideModal={onHide}
                            method='post'
                            jobs={jobs}
                            openModal={openModal}
                            scheduleInterview={onInterview}
                            fullJob={fullJob}
                        />
                    </>
                )}
                {showSummary && getSummaryContent()}
            </Modal.Body>
        </Modal>
    )

    function getSummaryContent() {
        return (
            <Row className="d-flex mt-4">
                <Col xs={7}>
                    {getSummaryRow(
                        CalendarIcon,
                        'Date',
                        selectedDate &&
                            moment(selectedDate.selectDate).format('LL')
                    )}
                    {selectedTimes.map((t, idx) => (
                        <React.Fragment key={idx}>
                            {getSummaryRow(
                                ClockIcon,
                                'Time',
                                `${t.hour}:${t.minute} ${
                                    t.isAM === 'AM' ? 'AM' : 'PM'
                                } ${t.timeZone}`
                            )}
                        </React.Fragment>
                    ))}
                    {getSummaryRow(
                        ResumeIcon,
                        'Event description',
                        description
                    )}
                </Col>
                <Col xs={5}>
                    {getSummaryRow(
                        WorkIcon,
                        'Interviewers',
                        interviewers.map((i) => i.name).toString()
                    )}
                    {selectedStages.map((s) => {
                        return (
                            <React.Fragment key={s.label}>
                                {getSummaryRow(ResumeIcon, 'Stage', s.label)}
                            </React.Fragment>
                        )
                    })}

                    <div className={styles.emailCheackbox}>
                        <Form.Check
                            className={styles.Checkbox}
                            type="checkbox"
                            value="chalender"
                            name="chalendar"
                            checked={checkedCalender}
                            readOnly
                        />
                        <span className={styles.textCheckbox}>
                            Send Google calendar invite to added interviewers
                        </span>
                    </div>
                    <div className={styles.emailCheackbox}>
                        <Form.Check
                            className={styles.Checkbox}
                            type="checkbox"
                            value="chalender"
                            name="chalendar"
                            checked={checkedEmail}
                            readOnly
                        />
                        <span className={styles.textCheckbox}>
                            Send email to candidate
                        </span>
                    </div>
                    <div className={styles.emailCheackbox}>
                        <Form.Check
                            className={styles.Checkbox}
                            type="checkbox"
                            value="chalender"
                            name="chalendar"
                            checked={checkedCalender}
                            readOnly
                        />
                        <span className={styles.textCheckbox}>
                            Send Google calendar invite to the candidate
                        </span>
                    </div>
                </Col>
            </Row>
        )
    }

    function getSummaryRow(icon, title, value) {
        return (
            <div className="mb-4 d-flex">
                <div className={styles.iconContainer}>
                    <Image
                        src={icon}
                        style={{ width: '16px', height: '16px' }}
                    />
                </div>
                <div className="d-flex flex-column ml-3">
                    <span>{title}:</span>
                    <p>{value}</p>
                </div>
            </div>
        )
    }

    // function resetState() {
    //     setShowSummary(false)
    //     setInterviews([createBlankInterview()])
    //     setInterviewers([])
    //     setShowAtMentionInput(false)
    //     setSelectedDate(undefined)
    //     setCheckedEmail(false)
    //     setCheckedCalender(false)
    //     setDescription(undefined)
    //     setSelectedTimes([])
    //     setSelectedStages([])
    // }
}

// function createBlankInterview() {
//     return { id: nanoid(), date: null, time: null, stage: null }
// }

export default ScheduleModel
