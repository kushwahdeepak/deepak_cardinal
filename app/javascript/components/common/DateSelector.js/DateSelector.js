import React, { useState, useEffect } from 'react'
import DatePicker from 'react-datepicker'
import feather from 'feather-icons'
import moment from 'moment'

import 'react-datepicker/dist/react-datepicker.css'
import './styles/DateSelector.css'

function DateSelector({
    handleOnSubmit,
    submitName,
    dateselected,
    isDateReadOnly = false,
}) {
    const [selectDate, setSelectDate] = useState(
        dateselected ? new Date(dateselected) : new Date()
    )
    const [isOpen, setIsOpen] = useState(false)
    const isWeekday = (date) => {
        const day = date.getDay(date)
        return day !== 0 && day !== 6
    }

    useEffect(() => {
        feather.replace()
    })

    const handleChange = (date) => {
        setSelectDate(date)
        setIsOpen(!isOpen)
        handleOnSubmit(date)
    }

    const handleClick = () => {
        if (isDateReadOnly) setIsOpen(false)
        else setIsOpen(!isOpen)
    }

    const ExampleCustomInput = React.forwardRef(({ onClick }, ref) => (
        <button
            className="exampleCustomInput"
            onClick={() => {
                handleClick()
            }}
            style={{
                background: `${selectDate === null ? '#4c68ff' : '#EBEDFA'}`,
                color: `${selectDate !== null ? '#4c68ff' : '#EBEDFA'}`,
                border: `${selectDate !== null ? '1px solid #4C68FF' : ''}`,
                width: '255px',
                minWidth: '255px',
                maxWidth: '255px',
            }}
            ref={ref}
        >
            {selectDate !== null
                ? `${moment(selectDate).format(
                      'MMM'
                  )} ${selectDate?.getDate()} `
                : 'Calender'}
            <span className="calenderIconContainer">
                <svg
                    xmlns="http://www.w3.org/2000/svg"
                    width="22"
                    height="22"
                    viewBox="0 0 24 24"
                    fill={`${selectDate === null ? '#4c68ff' : '#EBEDFA'}`}
                    stroke={`${selectDate !== null ? '#4c68ff' : '#EBEDFA'}`}
                    strokeWidth="2"
                    className="feather feather-calendar"
                >
                    <rect
                        x="3"
                        y="4"
                        width="18"
                        height="18"
                        rx="2"
                        ry="2"
                    ></rect>
                    <line x1="16" y1="2" x2="16" y2="6"></line>
                    <line x1="8" y1="2" x2="8" y2="6"></line>
                    <line x1="2" y1="10" x2="20" y2="10"></line>
                </svg>
            </span>
        </button>
    ))
    return (
        <DatePicker
            filterDate={isWeekday}
            showPopperArrow={false}
            onChange={handleChange}
            useWeekdaysShort={true}
            customInput={<ExampleCustomInput />}
            formatWeekDay={(nameOfDay) => nameOfDay.substr(0, 1)}
            selected={selectDate}
            open={isOpen}
            minDate={new Date()}
        >
            <i className="arrowRight" data-feather="chevron-right"></i>
            <i className="arrowLeft" data-feather="chevron-left"></i>
        </DatePicker>
    )
}

export default DateSelector
