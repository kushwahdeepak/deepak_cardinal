import React, { useState, useEffect } from 'react'
import DateSelector from '../DateSelector.js/DateSelector'
import TimePicker from '../TimePicker/TimePicker'
import Dropdown from 'react-bootstrap/Dropdown'
import Button from 'react-bootstrap/Button'
import feather from 'feather-icons'
import XButton from '../XButton/XButton'
import { nanoid } from 'nanoid'
import './styles/ScheduleInterviewDetails.scss'
import styles from './styles/ScheduleInterviewDetails.module.scss'

function GetInterviewRow({
    interviews,
    setInterviews,
    interviewData,
    interviewIndex,
    setSelectedDate,
    selectedDate,
    selectedTimes,
    selectedStages,
    setSelectedTimes,
    setSelectedStages,
    candidate,
    dateselected,
    stageError,
    dateError,
    timeError,
    setStageError,
    setTimeError,
    amError,
    setAmError,
    setHaveError,
    haveError,
}) {
  const allStages = [
    { id: 'applicant', label: 'Applicant' },
    { id: 'recruitor_screen', label: 'Recruiter Screen' },
    { id: 'submitted', label: 'Submitted' },
    { id: 'first_interview', label: 'First interview' },
    { id: 'second_interview', label: 'Second interview' },
    { id: 'offer', label: 'Offer' },
    { id: 'reject', label: 'Archive' },
]
    useEffect(() => {
        feather.replace()
    })
    const handleDelete = () => {
        const newInterviews = interviews.slice()
        newInterviews.splice(interviewIndex, 1)
        setInterviews(newInterviews)
        const clone = selectedStages
        clone.splice(interviewIndex, 1)
        setSelectedStages(clone)
        const timeclone = selectedTimes
        timeclone.splice(interviewIndex, 1)
        setSelectedTimes(timeclone)
    }
    return (
        <div
            key={interviewData.id}
            className={`${styles.interviewRow} ${
                interviewIndex > 0 ? styles.hoverPanel : ''
            }`}
        >
            <div
                style={{
                    visibility: interviewIndex === 0 ? 'visible' : 'hidden',
                }}
                className={styles.dateSelectorContainer}
            >
                <DateSelector
                    handleOnSubmit={(date) => setSelectedDate(date)}
                    submitName="Select"
                    dateselected={selectedDate}
                />
                {dateError && (
                    <p style={{ color: 'red' }}>Please select interview date</p>
                )}
            </div>
            <div className={styles.timePickerContainer}>
                <TimePicker
                    selectedTimes={selectedTimes}
                    handleOnTime={(time) => {
                        const clone = selectedTimes
                        clone[interviewIndex] = time
                        setSelectedTimes(clone)
                        setTimeError(timeError - 1)
                        setAmError(false)
                    }}
                />
                {selectedTimes[interviewIndex]?.timezoneerr !=
                'You are scheduling interviews outside normal' ? (
                    <p style={{ color: 'red', wordBreak: 'break-all' }}>
                        {selectedTimes[interviewIndex]?.timezoneerr}
                    </p>
                ) : (
                    <p style={{ color: 'red' }}>
                        You are scheduling interviews outside normal
                        <br /> working hours.
                    </p>
                )}
            </div>
            <div className={styles.dropdownContainer}>
                <Dropdown>
                    <Dropdown.Toggle>
                        {selectedStages[interviewIndex] &&
                        selectedStages[interviewIndex].label
                            ? selectedStages[interviewIndex].label
                            : 'Select Stage'}
                    </Dropdown.Toggle>
                    <Dropdown.Menu>
                        {allStages.map((stage, stageIndex) => (
                            <Dropdown.Item
                                key={stageIndex}
                                onSelect={(e) => {
                                    const clone = selectedStages.slice()
                                    clone[interviewIndex] = {
                                        ...allStages[stageIndex],
                                    }
                                    setSelectedStages(clone)
                                    setStageError(false)
                                }}
                                value={stage.id}
                                eventKey={stage.id}
                            >
                                {stage.label}
                            </Dropdown.Item>
                        ))}
                    </Dropdown.Menu>
                    {haveError === 0 ? (
                        ''
                    ) : selectedStages[interviewIndex] &&
                      selectedStages[interviewIndex].label ? (
                        ''
                    ) : (
                        <p style={{ color: 'red' }}>
                            Please select interview stage
                        </p>
                    )}
                </Dropdown>
            </div>
        {interviewIndex > 0 && (
          <div className={styles.deleteButtonContainer + ' .btn'}>
            <XButton
              onClick={(e) => {
                handleDelete()
              }}
            />
          </div>
        )}
      </div>
    )
}

export default GetInterviewRow
