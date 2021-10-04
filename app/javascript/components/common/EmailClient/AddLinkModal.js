import React, { useState, useEffect } from 'react'
import Modal from 'react-bootstrap/Modal'
import Button from 'react-bootstrap/Button'
import Row from 'react-bootstrap/Row'
import Container from 'react-bootstrap/Container'

import './styles/EmailClient.scss'

const AddLinkModal = ({ initialText, showModal, closeModal, getText }) => {
    const [urlToGo, setUrlToGo] = useState('')
    const [textToDisplay, setTextToDisplay] = useState(initialText)

    const handleClose = () => closeModal(false)
    const handleOk = () => {
        if (!isValidUrl(urlToGo)) {
            alert('Please enter valid url')
        } else {
            getText(textToDisplay, urlToGo)
            closeModal(false)
        }
    }

    const URL_VALIDATION_REGEX = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/

    const isValidUrl = (url) => {
        return new RegExp(URL_VALIDATION_REGEX).test(url)
    }

    useEffect(() => {
        setTextToDisplay(initialText)
    }, [initialText])

    return (
        <>
            <Modal
                show={showModal}
                onHide={handleClose}
                centered
                dialogClassName="center-modal"
            >
                <Modal.Header closeButton className="border-0">
                    <Modal.Title>Edit link</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <Container>
                        <Row className="mb-1">
                            <span>Text to display:</span>{' '}
                        </Row>
                        <Row className="mb-3">
                            <input
                                type="text"
                                className="flex-grow-1"
                                value={textToDisplay}
                                onChange={(e) =>
                                    setTextToDisplay(e.target.value)
                                }
                            />
                        </Row>
                        <Row className="mb-1">
                            <span>Link to:</span>
                        </Row>
                        <Row className="mb-3">
                            <input
                                className="flex-grow-1"
                                type="text"
                                // pattern="https://.*"
                                placeholder="https://example.com"
                                onChange={(e) => setUrlToGo(e.target.value)}
                            />
                        </Row>
                        <Row>
                            <Button
                                variant="link"
                                target="_blank"
                                className="pl-0"
                                href={`${urlToGo}`}
                            >
                                Test this link
                            </Button>
                        </Row>
                    </Container>
                </Modal.Body>
                <Modal.Footer className="border-0">
                    <Button variant="secondary" onClick={handleClose}>
                        Cancel
                    </Button>
                    <Button variant="primary" onClick={handleOk}>
                        Ok
                    </Button>
                </Modal.Footer>
            </Modal>
        </>
    )
}

export default AddLinkModal
