import React, { useState } from 'react'
import {
    Col,
    Container,
    Image,
    Row,
    Button,
    Alert,
    Modal,
} from 'react-bootstrap'
import Fab from '@material-ui/core/Fab'
import AddIcon from '@material-ui/icons/Add'
import DeleteIcon from '@material-ui/icons/Delete'
import isEmpty from 'lodash.isempty'

function AddNewReferralUser({
    inviteesDetails,
    handleInputName,
    handleInputEmail,
    handleAddNewRow,
    handleDeleteRow,
    setInvitationMessage,
}) {
    return (
        <Container>
            {inviteesDetails.map((detail, index) => {
                return (
                    <>
                        <Row
                            className="justify-content-md-between align-items-top mt-1"
                            key={index}
                        >
                            <Col
                                xs={5}
                                className="d-flex flex-row align-items-baseline"
                            >
                                <input
                                    type="text"
                                    placeholder="Enter Name"
                                    onChange={(event) => {
                                        handleInputName(event, index)
                                    }}
                                    className="form-control"
                                    value={detail.invitee_name}
                                ></input>
                            </Col>

                            <Col
                                xs={5}
                                className="d-flex flex-row align-items-baseline"
                            >
                                <input
                                    type="text"
                                    placeholder="Enter Email"
                                    onChange={(event) => {
                                        handleInputEmail(event, index)
                                    }}
                                    className="form-control"
                                    value={detail.invitee_email}
                                ></input>
                            </Col>

                            <Col
                                xs={2}
                                className="d-flex flex-row align-items-baseline"
                            >
                                <Fab
                                    size="small"
                                    color="primary"
                                    aria-label="add"
                                >
                                    <AddIcon
                                        onClick={() => handleAddNewRow()}
                                    />
                                </Fab>

                                <Fab
                                    style={{ marginLeft: '10px' }}
                                    size="small"
                                    color="primary"
                                    aria-label="add"
                                >
                                    <DeleteIcon
                                        onClick={() => handleDeleteRow(index)}
                                        size="small"
                                    />
                                </Fab>
                            </Col>
                        </Row>
                    </>
                )
            })}

            <Row className="justify-content-md-between align-items-top mt-2">
                <Col xs={12} className="d-flex flex-row align-items-baseline">
                    <input
                        type="textarea"
                        placeholder="Enter Message"
                        onChange={(event) => {
                            setInvitationMessage(event.target.value)
                        }}
                        className="form-control"
                    ></input>
                </Col>
            </Row>
        </Container>
    )
}

export default AddNewReferralUser
