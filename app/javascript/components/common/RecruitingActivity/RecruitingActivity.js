import React, { useState } from 'react'
import Card from 'react-bootstrap/Card'
import Tabs from 'react-bootstrap/Tabs'
import Tab from 'react-bootstrap/Tab'
import Form from 'react-bootstrap/Form'
import { nanoid } from 'nanoid'
import './styles/RecruitingActivity.scss'

function renderCheckboxBlock(checkboxData, withinPeriodKey) {
    return (
        <div className={`checkboxes-wrap`} key={checkboxData.id}>
            <label className="message-received-checkbox">
                <input
                    type="checkbox"
                    className="received-filter-checkbox"
                    checked={checkboxData.isChecked}
                    onChange={() => {
                        checkboxData.update(
                            checkboxData.isChecked ? '' : withinPeriodKey
                        )
                        checkboxData.handler((prevState) => !prevState)
                    }}
                />
                <span className="received-filter-span">
                    {checkboxData.title}
                </span>
            </label>
        </div>
    )
}

const RecruitingActivity = (props) => {
    const { setSelectWithinValue } = props

    const [withinPeriodKey, setWithinPeriodKey] = useState('week')
    const [receivedCheckboxState, setReceivedCheckboxState] = useState(false)

    // No BE support yet
    // const [sentCheckboxState, setSentCheckboxState] = useState(false)
    // const [interviewCheckboxState, setInterviewCheckboxState] = useState(false)
    // const [offerCheckboxState, setOfferCheckboxState] = useState(false)
    // const [rejectionCheckboxState, setRejectionCheckboxState] = useState(false)
    const checkboxesData = [
        {
            title: 'Messages Received',
            isChecked: receivedCheckboxState,
            handler: setReceivedCheckboxState,
            update: setSelectWithinValue,
            id: nanoid(),
        },
        // { No BE support yet
        //     title: 'Messages Sent',
        //     isChecked: sentCheckboxState,
        //     handler: setSentCheckboxState,
        //     id: nanoid(),
        // },
        // {
        //     title: 'Interview',
        //     isChecked: interviewCheckboxState,
        //     handler: setInterviewCheckboxState,
        //     id: nanoid(),
        // },
        // {
        //     title: 'Profile Reviewed',
        //     isChecked: profileReviewedCheckboxState,
        //     handler: setProfileReviewedCheckboxState,
        //     id: nanoid(),
        // },
        // {
        //     title: 'Offer',
        //     isChecked: offerCheckboxState,
        //     handler: setOfferCheckboxState,
        //     id: nanoid(),
        // },
        // {
        //     title: 'Rejection',
        //     isChecked: rejectionCheckboxState,
        //     handler: setRejectionCheckboxState,
        //     id: nanoid(),
        // },
    ]

    const handleSelectChange = (event) => {
        const value = event.target.value
        setSelectWithinValue(value)
    }

    return (
        <Card className="shadow-sm recruiting-card">
            <h4>Recruiter activity:</h4>

            <Card.Body className="recruiting-card__body">
                <Tabs
                    defaultActiveKey="people_without"
                    className="recruiting-activity-tabs"
                >
                    <Tab eventKey="people_with" title="People with"></Tab>
                    <Tab eventKey="people_without" title="People without">
                        {checkboxesData.map((checkbox) => {
                            return renderCheckboxBlock(
                                checkbox,
                                withinPeriodKey
                            )
                        })}
                        <Form.Group
                            className="within-block"
                            controlId="exampleForm.SelectCustom"
                        >
                            <Form.Label> Within:</Form.Label>
                            <Form.Control
                                onChange={(event) => {
                                    setWithinPeriodKey(event.target.value)
                                    if (receivedCheckboxState) {
                                        handleSelectChange(event)
                                    }
                                }}
                                as="select"
                                custom
                            >
                                <option value="week">Past week</option>
                                <option value="month">Past month</option>
                                <option value="year">Past year</option>
                            </Form.Control>
                        </Form.Group>
                    </Tab>
                </Tabs>
            </Card.Body>
        </Card>
    )
}

export default RecruitingActivity
