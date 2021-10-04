import React, { useState, useEffect } from 'react'
import DatePicker from 'react-datepicker'
import feather from 'feather-icons'
import moment from 'moment'

import 'react-datepicker/dist/react-datepicker.css'
import './styles/DateRangePicker.css'

function DateRangePicker({ handleOnSubmit, defaultDate }) {
    const { startDate: start, endDate: end } = defaultDate
    const [isOpen, setIsOpen] = useState(false)
    const [startDate, setStartDate] = useState(new Date(start))
    const [endDate, setEndDate] = useState(new Date(end))

    useEffect(() => {
        feather.replace()
    })

    const handleChange = (dates) => {
        const [start, end] = dates
        setStartDate(start)
        setEndDate(end)
    }

    const handleFilter = () => {
        setIsOpen(!isOpen)
        if(endDate === null){
            handleOnSubmit({ startDate, startDate })
            setEndDate(startDate)
        }else{
            handleOnSubmit({ startDate, endDate })
        }
    }
    const handleClick = () => {
        setIsOpen(!isOpen)
    }

    const ExampleCustomInput = React.forwardRef(({ onClick }, ref) => (
        <button
            className="exampleCustomInput"
            onClick={() => {
                onClick()
                handleClick()
            }}
            style={{
                background: `${endDate === null ? '#4c68ff' : '#EBEDFA'}`,
                color: `${endDate !== null ? '#4c68ff' : '#EBEDFA'}`,
                border: `${endDate !== null ? '1px solid #4C68FF' : ''}`,
            }}
            ref={ref}
        >
            {endDate !== null
                ? `${moment(startDate).format(
                      'MMM'
                  )} ${startDate?.getDate()} - ${moment(endDate).format(
                      'MMM'
                  )} ${endDate?.getDate()}`
                : 'Calendar'}
            <span className="calenderIconContainer">
                <svg
                    xmlns="http://www.w3.org/2000/svg"
                    width="30"
                    height="30"
                    viewBox="0 0 24 24"
                    fill={`${endDate === null ? '#4c68ff' : '#EBEDFA'}`}
                    stroke={`${endDate !== null ? '#4c68ff' : '#EBEDFA'}`}
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
            showPopperArrow={false}
            onChange={handleChange}
            useWeekdaysShort={true}
            customInput={<ExampleCustomInput />}
            formatWeekDay={(nameOfDay) => nameOfDay.substr(0, 1)}
            startDate={startDate}
            endDate={endDate}
            selected={startDate}
            selectsRange
            open={isOpen}
        >
            <button onClick={() => handleFilter()} className="dateFilter">
                Filter
            </button>
            <i className="arrowRight" data-feather="chevron-right"></i>
            <i className="arrowLeft" data-feather="chevron-left"></i>
        </DatePicker>
    )
}

export default DateRangePicker
