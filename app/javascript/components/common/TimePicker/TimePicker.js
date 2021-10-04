import React, { useState, useRef, Fragment, useEffect } from 'react'

import styles from './styles/TimePicker.module.scss'
import './styles/TimePicker.scss'
import Dropdown from 'react-bootstrap/Dropdown'

function TimePicker({ handleOnTime, selectedTimes, hideTimeZone = false, isTimeReadonly = false }) {
  const [isAM, setIsAM] = useState(selectedTimes[0]&&selectedTimes[0].isAM ? selectedTimes[0]&&selectedTimes[0].isAM : 'PM')
  const [hour, setHour] = useState(selectedTimes[0]&&selectedTimes[0].hour ? selectedTimes[0]&&selectedTimes[0].hour : '')
  const [minute, setMinute] = useState(selectedTimes[0]&&selectedTimes[0].minute ? selectedTimes[0]&&selectedTimes[0].minute : '')
  const [timeZone, setTimeZone] = useState(selectedTimes[0]&&selectedTimes[0].timeZone ? selectedTimes[0]&&selectedTimes[0].timeZone : 'Time-zone')
  const hourRef = useRef()
  const minRef = useRef()

  const allTimezones = [
    { id: 'EST', label: 'EST' },
    { id: 'CST', label: 'CST' },
    { id: 'MST', label: 'MST' },
    { id: 'PDT', label: 'PDT' },
]
useEffect(() => {
    setIsAM(selectedTimes[0]&&selectedTimes[0].isAM ? selectedTimes[0]&&selectedTimes[0].isAM : 'PM')
    setHour(selectedTimes[0]&&selectedTimes[0].hour ? selectedTimes[0]&&selectedTimes[0].hour : '')
    setMinute(selectedTimes[0]&&selectedTimes[0].minute ? selectedTimes[0]&&selectedTimes[0].minute : '')
}, [selectedTimes])

  const handleHour = (e) => {
    if (e.target.value <= 12 && e.target.value.length<=2) {
      setHour(e.target.value)
    }

    if (e.target.value.length >= e.target.maxLength) {
      minRef.current.focus()
    }
  }

  const handleMinute = (e) => {
    if (e.target.value <= 59 && e.target.value.length<=2) {
      setMinute(e.target.value)
    }
  }
  const handleTimeZone = (value) => {
    setTimeZone(value)
  }

  useEffect(() => {
    handleOnTime({
      hour:
          hour == undefined
            ? '00'
            : hour.length == 1 && hour < 10
            ? '0' + hour
            : hour,
      minute:
        minute == undefined
            ? '00'
            : minute.length == 1 && minute < 10
            ? '0' + minute
            : minute,
      isAM,
      timeZone,
    })
  }, [hour, minute, isAM, timeZone])

  return (
      <Fragment>
          <div className={styles.timePickerWrapper}>
              <div className={styles.timePickerContainer}>
                  <div className={styles.timeInputContainer}>
                      <input
                          ref={hourRef}
                          name="hour"
                          type="number"
                          placeholder="00"
                          maxLength="2"
                          min="00"
                          max="12"
                          className={styles.timeInput}
                          value={hour}
                          onChange={(e) => handleHour(e)}
                          readOnly={isTimeReadonly}
                      />
                      :
                      <input
                          ref={minRef}
                          name="minute"
                          type="number"
                          placeholder="00"
                          maxLength="2"
                          min="00"
                          max="59"
                          className={styles.timeInput}
                          value={minute}
                          onChange={(e) => handleMinute(e)}
                          readOnly={isTimeReadonly}
                      />
                  </div>
                  {isTimeReadonly ? (
                      <div className={styles.ampmContainer}>
                        <span>
                          {isAM}
                        </span>
                      </div>
                  ) : (
                      <div className={styles.ampmButtonContainer}>
                          <button
                              style={{
                                  backgroundColor: `${
                                      isAM === 'AM' ? '#778CFF' : ' #D7DBF3'
                                  }`,
                              }}
                              className={styles.apbutton}
                              onClick={() => setIsAM('AM')}
                          >
                              {' '}
                              AM
                          </button>
                          <button
                              style={{
                                  backgroundColor: `${
                                      isAM === 'AM' ? ' #D7DBF3' : '#778CFF'
                                  }`,
                              }}
                              className={styles.apbutton}
                              onClick={() => setIsAM('PM')}
                          >
                              PM
                          </button>
                      </div>
                  )}
                  {!hideTimeZone && (
                      <div className={styles.timeZoneContainer}>
                          <Dropdown style={{ background: '#778CFF' }}>
                              <Dropdown.Toggle
                                  id="dropdown-basic"
                                  style={{
                                      background: '#778CFF',
                                      color: 'white',
                                      border: 'none',
                                      width: '95px',
                                      height: '27px',
                                  }}
                              >
                                  {timeZone != 'Time-zone'
                                      ? allTimezones.map((row) =>
                                            timeZone === row.id ? row.label : ''
                                        )
                                      : 'TimeZone'}
                              </Dropdown.Toggle>
                              <Dropdown.Menu
                                  style={{
                                      overflowY: 'scroll',
                                      height: '100px',
                                      left: '-52px',
                                      inset: '0px auto auto -4px',
                                  }}
                                  className="timeZoneToggle"
                              >
                                  {allTimezones.map(
                                      (timeZone, timeZoneIndex) => (
                                          <Dropdown.Item
                                              key={timeZoneIndex}
                                              onSelect={(e) => {
                                                  setTimeZone(timeZone.id)
                                              }}
                                              value={timeZone.id}
                                              eventKey={timeZone.id}
                                          >
                                              {timeZone.label}
                                          </Dropdown.Item>
                                      )
                                  )}
                              </Dropdown.Menu>
                          </Dropdown>
                      </div>
                  )}
              </div>
          </div>
      </Fragment>
  )
}

export default TimePicker
