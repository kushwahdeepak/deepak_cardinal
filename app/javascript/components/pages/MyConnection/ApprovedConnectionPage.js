import React, { Fragment } from 'react'

import './styles/MyConnectionPage.scss'
import { Card, W4text, InfoContainer, W8text, W5text} from './styles/MyConnection.styled'

function ApprovedConnectionPage({ contacts }) {
    if (contacts.length === 0) {
        return (
            <div className="card-body d-flex justify-content-center">
                <W4text color="#4C68FF" size="14px">
                    No Approved Contacts
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
                                </Card>
                            </div>
                        </div>
                    </div>
                </Fragment>
            ))}
        </div>
    )
}

export default ApprovedConnectionPage
