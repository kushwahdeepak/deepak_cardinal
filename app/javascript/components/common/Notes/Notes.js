import React, { useState, useEffect } from 'react'
import Container from 'react-bootstrap/Container'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import Button from 'react-bootstrap/Button'
import Card from 'react-bootstrap/Card'
import Alert from 'react-bootstrap/Alert'
import AddNote from '../AddNote/AddNote'
import moment from 'moment'
import axios from 'axios'
import feather from 'feather-icons'

import styles from './styles/Notes.module.scss'

function Notes({ notes, candidate, setNotes }) {
    const [showAddNoteModal, setShowAddNoteModal] = useState(false)
    const [noteAdded, setNoteAdded] = useState(false)
    const [errorFetchingNotes, setErrorFetchingNotes] = useState(null)

    useEffect(() => {
        axios
            .get(`/people/${candidate.id}.json`)
            .then((res) => {
                setNotes(res.data.notes)
            })
            .catch((e) => setErrorFetchingNotes(e.message))
    }, [noteAdded])

    useEffect(() => {
        feather.replace()
    })

    return (
        <Container>
            {errorFetchingNotes && (
                <Alert
                    variant="danger"
                    onClose={() => setErrorFetchingNotes(null)}
                    dismissible
                >
                    {errorFetchingNotes}
                </Alert>
            )}
            <Row className="flex-column">
                <Col xs="auto">
                    <p className={styles.text}>Notes</p>
                </Col>
                <Col xs="auto">
                    <Button
                        variant="link"
                        className={styles.text + ' p-0'}
                        data-test="open-modal-btn"
                        onClick={() => setShowAddNoteModal(true)}
                    >
                        <i data-feather="plus-circle"></i> Add new note
                    </Button>
                </Col>
            </Row>
            <AddNote
                show={showAddNoteModal}
                onHide={() => setShowAddNoteModal(false)}
                candidate={candidate}
                setNoteAdded={setNoteAdded}
            />
            {notes &&
                notes.map((note) => (
                    <Card className="mb-2" key={note.id}>
                        <Card.Body>
                            <Row>
                                <Col>
                                    <Row className="mb-2">
                                        <Col>
                                            {note.user && note.user.email}
                                        </Col>
                                        <Col xs={4}>
                                            {moment(note.created_at).format(
                                                'DD MMM, YYYY  HH:mm'
                                            )}
                                        </Col>
                                    </Row>
                                    <Row>
                                        <Col>{note.body}</Col>
                                    </Row>
                                </Col>
                            </Row>
                        </Card.Body>
                    </Card>
                ))}
        </Container>
    )
}

export default Notes
