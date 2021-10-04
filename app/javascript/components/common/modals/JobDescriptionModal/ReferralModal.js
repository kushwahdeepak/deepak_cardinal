import React, { useState } from 'react'
import axios from 'axios'
import {
    Button,
    Alert,
    Modal,
    Spinner
} from 'react-bootstrap'

import AddNewReferralUser from './AddNewReferralUser'
import validator from 'validator'

function ReferralModal({
    onHide,
    show,
    job,
    setErrorCreatingSubmission,
    setAlertApplyForJob,
}) {
    const [inviteesDetails, setInviteesDetails] = useState([
        { invitee_email: '', invitee_name: '' },
    ])
    const [invitationMessage, setInvitationMessage] = useState('')
    const [errorModel, setErrorModel] = useState(null)
    const [loading, setLoading] = useState(false)

    const handleAddNewRow = () => {
        let temporaryInviteesDetails = inviteesDetails.slice()
        temporaryInviteesDetails.push({ invitee_email: '', invitee_name: '' })
        setInviteesDetails(temporaryInviteesDetails)
    }

    const handleDeleteRow = (index) => {
        let temporaryInviteesDetails = inviteesDetails.slice()
        if (temporaryInviteesDetails.length > 1) {
            temporaryInviteesDetails.splice(index, 1)
            setInviteesDetails(temporaryInviteesDetails)
        }
    }

    const handleInputName = (event, index) => {
        let temporaryInviteesDetails = inviteesDetails.slice()
        temporaryInviteesDetails[index].invitee_name = event.target.value
        setInviteesDetails(temporaryInviteesDetails)
    }

    const handleInputEmail = (event, index) => {
        let temporaryInviteesDetails = inviteesDetails.slice()
        temporaryInviteesDetails[index].invitee_email = event.target.value
        setInviteesDetails(temporaryInviteesDetails)
    }

    const handleInvite = async () => {
        const token = document.querySelector('meta[name="csrf-token"]').content

        let payload = {
            authenticity_token: token,
            job_id: job.id,
        }
        let isError = true;
        payload['referrals'] = inviteesDetails
        payload['message'] = invitationMessage
        inviteesDetails.map(value => {
            if(value.invitee_email === ''){
                setErrorModel("Please Enter Email")
                isError = false
            }
            if (!validator.isEmail(value.invitee_email)) {
                setErrorModel("Please Enter valid Email")
                isError = false
            }
            if(value.invitee_name === ''){
                setErrorModel("Please Enter Name")
                isError = false
            }
        });
        if(invitationMessage === ''){
            setErrorModel("Please Enter Message")
            isError = false
        }
        if(isError){
            setLoading(true)
            try {
                const { data } = await axios.post('/referrals.json', payload)

                if (data.hasOwnProperty('error')) {
                    setErrorCreatingSubmission(data.error)
                    setLoading(false)
                } else {
                    setLoading(false)
                    setInviteesDetails([
                        { invitee_email: '', invitee_name: '' },
                    ])
                    setAlertApplyForJob(
                        'Invited Successfully'
                    )
                }
            } catch (error) {
                setErrorCreatingSubmission(error.message)
                setLoading(false)
            }
            onHide()
        }
    }

    return (
        <Modal
            onHide={onHide}
            show={show}
            size="lg"
            aria-labelledby="contained-modal-title-vcenter"
            centered
            scrollable
        >
            <Modal.Header closeButton>
                <Modal.Title id="contained-modal-title-vcenter">
                    {'Invitations'}
                </Modal.Title>
            </Modal.Header>
            <Modal.Body>
                    {errorModel && (
                            <Alert
                              variant="danger"
                              onClose={() => setErrorModel(null)}
                              dismissible
                            >
                             {errorModel}
                            </Alert>    
                    )}
                    {loading && (
                        <div className="d-flex justify-content-center">
                            <Spinner animation="border" role="status">
                                <span className="sr-only">Loading...</span>
                            </Spinner>
                        </div>
                    )}
                <AddNewReferralUser
                    inviteesDetails={inviteesDetails}
                    handleAddNewRow={handleAddNewRow}
                    handleDeleteRow={(idx) => {
                        handleDeleteRow(idx)
                    }}
                    handleInputName={(event, index) => {
                        handleInputName(event, index)
                    }}
                    handleInputEmail={(event, index) => {
                        handleInputEmail(event, index)
                    }}
                    setInvitationMessage={(data) => {
                        setInvitationMessage(data)
                    }}
                />
            </Modal.Body>
            <Modal.Footer>
                <Button
                    href={'#'}
                    variant="primary"
                    onClick={() => {
                        handleInvite()
                    }}
                >
                    Invite
                </Button>
                <Button type="button"  onClick={() => {
                            onHide()
                        }}variant="secondary">
                    Close
                </Button>
            </Modal.Footer> 
        </Modal>
    )
}

export default ReferralModal
