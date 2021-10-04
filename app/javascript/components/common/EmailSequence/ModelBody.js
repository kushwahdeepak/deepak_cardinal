import React, { useRef, useState, useEffect } from 'react'
import { Quill } from 'react-quill'
import moment from 'moment'
import { Button, Tooltip, OverlayTrigger, Alert, Modal } from 'react-bootstrap'

import styles from './styles/EmailSequence.module.scss'
import CloseButton from '../Styled components/CloseButton'
import BulkCandidateUpload from '../BulkCandidateUpload/BulkCandidateUpload'
import DateSelector from '../DateSelector.js/DateSelector'
import TimePicker from '../TimePicker/TimePicker'
import './styles/EmailSequence.scss'
import EmailContent from '../EmailClient/EmailContent'
import { makeRequest } from '../RequestAssist/RequestAssist'

// Tell Quill to wrap sections with <div> instead of <p>
// (otherwise you get double lines due to: <p><br></p>)
const Block = Quill.import('blots/block')
Block.tagName = 'DIV'
Quill.register(Block, true)
function ModelBody({
    job,
    email,
    isEmailEditable,
    validTimeDifference,
    dispatch,
    index,
    setOpenEmailSequenceModal,
}) {
    const emailContentRef = useRef(null)
    const [time, setTime] = useState([])
    const [date, setDate] = useState(new Date(email.sent_at))
    const [isBulkUpload, setIsBulkUpload] = useState(false)
    const [validationErrors, setValidationErrors] = useState({})

    useEffect(() => {
        if (email.id.length !== 0) {
            const sentTime = moment(email.sent_at).format('hh:mm A')
            const splitedTime = sentTime.split(/[ :]+/)
            setTime([
                {
                    hour: splitedTime[0],
                    minute: splitedTime[1],
                    isAM: splitedTime[2],
                },
            ])

        }
    }, [index])

    const handleChange = (event, name) => {
        dispatch({
            type: 'changeState',
            name: name,
            index: index,
            value: event.target.value,
        })
    }

    const formatDate = () => {
        const formatDate = moment(date).format('MM/DD/YYYY')
        const formatTime = `${time[0].hour}:${time[0].minute} ${time[0].isAM}`
        const dateTime = `${formatDate} ${formatTime}`
        const sentAt = new Date(dateTime)
        return sentAt
    }

    const isValid = () => {
        if (email.subject === '') {
            setValidationErrors({
                ...validationErrors,
                error: 'Please enter Subject',
            })
            return false
        } else if (email.email_body.replace(/<[^>]*>/g, '') === '') {
            setValidationErrors({
                ...validationErrors,
                error: 'Please enter Emailbody',
            })
            return false
        } else if (
            (time[0].hour === '' && time[0].minute === '') ||
            time[0].hour === '00'
        ) {
            setValidationErrors({
                ...validationErrors,
                error: 'Please set Time',
            })
            return false
        }
        const sentAt = formatDate()

        if (moment(new Date()).isAfter(sentAt)) {
            setValidationErrors({
                ...validationErrors,
                error: 'Invalid Time',
            })
            return false
        }

        if (!validTimeDifference(email.sequence, sentAt)) {
            setValidationErrors({
                ...validationErrors,
                error: 'The difference between two email sequence should be 24 hours',
            })
            return false
        }

        return true
    }

    const handleSave = async () => {
        setValidationErrors({})
        if (isValid()) {
            const sentAt = formatDate()
            const formData = new FormData()
            formData.append('email_sequence[subject]', email.subject)
            formData.append('email_sequence[email_body]', email.email_body)
            formData.append('email_sequence[sent_at]', sentAt)
            formData.append('email_sequence[job_id]', job.id)
            formData.append('email_sequence[sequence]', email.sequence)
            if (!!email.id) {
                const url = `/email_sequence/update/${email.id}`

                const responce = await makeRequest(url, 'put', formData, {
                    contentType: 'application/json',
                    loadingMessage: 'Submitting...',
                    createSuccessMessage: (response) => response.data.message,
                })
                let newEmail = responce.data.mail
                dispatch({ type: 'updateEmail', index: index, value: newEmail })
                setOpenEmailSequenceModal(false)
                (window.location.href = `/jobs/${job.id}/${job.name}`)
            } else {
                const url = '/email_sequence/create'

                const responce = await makeRequest(url, 'post', formData, {
                    contentType: 'application/json',
                    loadingMessage: 'Submitting...',
                    createSuccessMessage: (response) => response.data.message,
                })
                let newEmail = responce?.data.mail
                dispatch({ type: 'updateEmail', index: index, value: newEmail })
                setOpenEmailSequenceModal(false)
                (window.location.href = `/jobs/${job.id}/${job.name}`)
            }
        }
    }
    const handleSubmit = async (bulkSpreadSheets) => {
        const url = `/email_sequence/bulk_upload/${email.id}`

        const formData = new FormData()
        for (let i = 0; i < bulkSpreadSheets.length; i++) {
            formData.append(
                'applicant_batch[candidate_files][]',
                bulkSpreadSheets[i]
            )
        }
        const responce = await makeRequest(url, 'post', formData, {
            contentType: 'application/json',
            loadingMessage: 'It will take few minutes',
            createSuccessMessage: (response) => response.data.message,
        })
        handleBulkUpload()
    }
    const handleBulkUpload = () => {
        setIsBulkUpload(!isBulkUpload)
    }

    const isReadOnly = (date) => {
        if (email.id === '') {
            return false
        } else if (moment(new Date()).isAfter(date)) {
            return true
        } else {
            return false
        }
    }
    return (
        <>
            {!isEmailEditable && (
                <h3 className="notifyText"> Please create previous email </h3>
            )}
            <div className={isEmailEditable ? '' : 'glass'}>
                <div className="EmailRow">
                    {Object.values(validationErrors).map((error) => (
                        <Alert
                            key={error}
                            variant="danger"
                            onClose={() => setValidationErrors({})}
                            dismissible
                            className="alert-close"
                        >
                            {error}
                        </Alert>
                    ))}
                    <div className={styles.dateSelectorContainer}>
                        <span className="mr-5">Sent On</span>
                        <DateSelector
                            handleOnSubmit={(date) => {
                                setDate(date)
                            }}
                            submitName="Select"
                            dateselected={date}
                            isDateReadOnly={isReadOnly(date)}
                        />
                    </div>

                    <div className={styles.timePickerContainer}>
                        <TimePicker
                            selectedTimes={time}
                            handleOnTime={(newTime) => {
                                const cloneTime = time
                                cloneTime[0] = newTime
                                setTime(cloneTime)
                            }}
                            hideTimeZone={true}
                            isTimeReadonly={isReadOnly(date)}
                        />
                    </div>
                </div>
                <div className="input-block mt-3">
                    <span className="mr-5">Subject</span>
                    <input
                        type="text"
                        value={email.subject}
                        className="regular-input"
                        onChange={(event) => handleChange(event, 'subject')}
                        readOnly={isReadOnly(date)}
                    />
                </div>
                <div className="body-third-row mt-3">
                    <EmailContent
                        getQuillRef={(quill) => {
                            emailContentRef.current = quill
                        }}
                        value={email.email_body}
                        inputChangeHandler={(event) =>
                            handleChange(event, 'email_body')
                        }
                        isReadOnly={isReadOnly(date)}
                    />
                    <div className="d-flex justify-content-between">
                        <div>
                            <OverlayTrigger
                                overlay={
                                    <Tooltip>
                                        {!!email.id
                                            ? isReadOnly(date)
                                                ? 'Date has been expired'
                                                : 'Upload Candidates'
                                            : 'You need create email sequence before uploading candidates'}
                                    </Tooltip>
                                }
                            >
                                <span className="d-inline-block">
                                    <button
                                        className="bulk-button"
                                        onClick={() => handleBulkUpload()}
                                        disabled={!email.id || isReadOnly(date)}
                                    >
                                        Click here to upload own candidates
                                    </button>
                                </span>
                            </OverlayTrigger>
                        </div>
                        <div style={{ alignSelf: 'center' }}>
                            <Button
                                className="save-button"
                                onClick={handleSave}
                            >
                                Save
                            </Button>
                        </div>
                    </div>
                </div>
            </div>
            <Modal
                className={`${styles.customModalmailSequence}`}
                show={isBulkUpload}
                onHide={() => setIsBulkUpload(false)}
                size={'xl'}
                aria-labelledby="contained-modal-title-vcenter"
                backdrop="static"
            >
                <Modal.Body className="bulk-upload-modal">
                    <div className="close-bulk">
                        <CloseButton
                            handleClick={() => setIsBulkUpload(!isBulkUpload)}
                        />
                    </div>
                    <BulkCandidateUpload
                        hideHeaderText={true}
                        hideUploadResume
                        isCustomFunction
                        handleCustomSubmit={handleSubmit}
                    />
                </Modal.Body>
            </Modal>
        </>
    )
}

export default ModelBody
