import React,{Fragment} from 'react'
import axios from 'axios'

import './styles/MyConnectionPage.scss'
import { Link, Card, Container, W4text, W8text, W5text, InfoContainer } from './styles/MyConnection.styled'


function ReceivedRequestConnectionPage({
    contacts,
    handleReceivedRequestTotalCount,
    handleReceivedContactRequests,
    handleReceivedContactsTotalPage,
    handleApprovedContactRequests,
    handleApprovedRequestTotalCount,
    handleAcceptedContactsTotalPage,
    handleErrorFetchingJob,
}) {
    const updateStatus = (status, id) => {
        const url = `/my_connections/${id}/update_status.json`
        const CSRF_Token = document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute('content')

        const payload = JSON.stringify({
            status: status,
        })

        axios
            .put(url, payload, {
                headers: {
                    'content-type': 'application/json',
                    'X-CSRF-Token': CSRF_Token,
                },
            })
            .then((res) => {
                if (res.data.status == 'success') {
                    handleReceivedContactRequests(
                        res.data.received_contact_requests
                    )
                    handleReceivedContactsTotalPage(
                        res.data.received_contact_total_page
                    )
                    handleReceivedRequestTotalCount(
                        res.data.received_contact_total_count
                    )
                    handleApprovedContactRequests(
                        res.data.accepted_contact_requests
                    )
                    handleApprovedRequestTotalCount(
                        res.data.accepted_contact_total_count
                    )
                    handleAcceptedContactsTotalPage(
                        res.data.accepted_contact_total_page
                    )
                }
            })
            .catch((error) => {
                console.log(error)
                handleErrorFetchingJob(error)
            })
    }

    if (contacts.length === 0) {
        return (
            <div className="card-body d-flex justify-content-center">
                <W4text color="#4C68FF" size="14px">
                    No Received Contacts
                </W4text>
            </div>
        )
    }

    return (
        <div className="row">
            {contacts.map((contact, index) => (
                <Fragment key={index}>
                    <div className="cord-container">
                        <div className="card contacts-card">
                            <div className="card-body">
                                <Card>
                                    <div>
                                        <img
                                            height="80px"
                                            width="80px"
                                            alt="Blank Profile"
                                            className="rounded-circle send-connection-img"
                                            src="https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
                                        />
                                    </div>
                                    <InfoContainer className="ml-3" jContent='center'>
                                        <W8text color="#465189" size="12px" className="mb-1"> {!!contact.full_name? contact.full_name: contact.email}</W8text>
                                       <W5text color="#465189" size="10px" className="mb-1"> {contact.job_title} </W5text>
                                       <W5text color="#465189" size="10px" className="mb-1"> {contact.full_address} </W5text>
                                    </InfoContainer>
                                    <div style={{flexGrow:1}}/>

                                    <Container direction="row">
                                        <Link
                                            onClick={(event) => {
                                                updateStatus(
                                                    'accepted',
                                                    contact.id
                                                )
                                            }}
                                            className="btn btn-primary"
                                            id="accept"
                                        >
                                            Accept
                                        </Link>
                                        <Link
                                            onClick={(event) => {
                                                updateStatus(
                                                    'rejected',
                                                    contact.id
                                                )
                                            }}
                                            className="btn btn-primary float-right"
                                            id="reject"
                                        >
                                            Reject
                                        </Link>
                                    </Container>
                                </Card>
                            </div>
                        </div>
                    </div>
                </Fragment>
            ))}
        </div>

    )
}

export default ReceivedRequestConnectionPage
