import React, { useState, useEffect, useReducer, useCallback } from 'react'
import { Spinner, Tabs, Tab } from 'react-bootstrap'
import axios from 'axios'
import moment from 'moment'

import ModelBody from './ModelBody.js'
import reducer from './reducer'

const defaultEmails = [
    {
        id: '',
        sequence: 'email1',
        subject: '',
        sent_at: new Date(),
        email_body: '',
    },
    {
        id: '',
        sequence: 'email2',
        subject: '',
        sent_at: new Date(),
        email_body: '',
    },
    {
        id: '',
        sequence: 'email3',
        subject: '',
        sent_at: new Date(),
        email_body: '',
    },
]

function EmailSequence({ job, openEmailSequenceModal, setOpenEmailSequenceModal }) {
    const [sequence, setSequence] = useState('email1')
    const [loading, setLoading] = useState(false)
    const [isEmailEditable, setIsEmailEditable] = useState(true)
    const [emails, dispatch] = useReducer(reducer, defaultEmails)
    useEffect(() => {
        setSequence('email1')
    }, [openEmailSequenceModal])

    useEffect(() => {
        fetchEmailSequence()
    }, [])

    useEffect(() => {
        isCreatable()
        emails.map((email, index) => {
            if (email.id === '') {
                dispatch({ type: 'clearState', index: index })
            }
        })
    }, [sequence])
    
    const fetchEmailSequence = async () => {
        const url = `/email_sequence/${job.id}`
        setLoading(true)
        const response = await axios
            .get(url)
            .then((res) => {
                const resultFound = res.data.found
                if (resultFound) {
                    let emailResponse = res.data.mail
                    const data = defaultEmails.map((email) => {
                        const emailFound = emailResponse.find((obj) => {
                            return obj.sequence === email?.sequence
                        })
                        if (emailFound) {
                            return { ...email, ...emailFound }
                        }
                        return { ...email }
                    })
                    dispatch({ type: 'updateState', value: data })
                }
            })
            .catch((error) => console.log(error))
        setLoading(false)
    }

    const isCreatable = () => {
        if (sequence === 'email2' && emails[0]?.id === '') {
            setIsEmailEditable(false)
        } else if (sequence === 'email3' && emails[1]?.id === '') {
            setIsEmailEditable(false)
        } else {
            setIsEmailEditable(true)
        }
    }

    const validTimeDifference = useCallback((sequence, date) => {
            if (sequence === 'email2') {
                return moment(date).diff(emails[0]?.sent_at, 'hours') >= 24
            } else if (sequence === 'email3') {
                return moment(date).diff(emails[1]?.sent_at, 'hours') >= 24
            } else return true
        },[emails])

    if (loading) {
        return (
            <div>
                <Spinner animation="border" role="status">
                    <span className="sr-only">Loading...</span>
                </Spinner>
            </div>
        )
    }

    return (
        <>
            <div className="container">
                <Tabs
                    defaultActiveKey="email1"
                    className="email-sequence-tabs"
                    onSelect={(eventKey) => {
                        setSequence(eventKey)
                    }}
                >
                    {emails?.map((email, index) => (
                        <Tab
                            key={index}
                            eventKey={email?.sequence}
                            title={`Email ${index + 1}`}
                        >
                            {email?.sequence === sequence && (
                                <ModelBody
                                    job={job}
                                    email={email}
                                    isEmailEditable={isEmailEditable}
                                    validTimeDifference={validTimeDifference}
                                    dispatch={dispatch}
                                    index={index}
                                    setOpenEmailSequenceModal={setOpenEmailSequenceModal}
                                />
                            )}
                        </Tab>
                    ))}
                </Tabs>
            </div>
        </>
    )
}

export default EmailSequence
