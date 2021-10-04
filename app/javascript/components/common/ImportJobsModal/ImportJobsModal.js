import React, { useState, useEffect } from 'react'
import Modal from 'react-bootstrap/Modal'
import Form from 'react-bootstrap/Form'
import {Col, Container, Row} from 'react-bootstrap'
import Alert from 'react-bootstrap/Alert'
import './styles/ImportJobsModal.scss'
import SuccessModal from '../../pages/JobsNewPage/SuccessModal/SuccessModal'
import AddCompanyLogo from '../../common/AddCompanyLogo/AddCompanyLogo'
import axios from 'axios'
import { nanoid } from 'nanoid'
import Button from 'react-bootstrap/Button'
import feather from 'feather-icons'
import DragAndDrop from '../../common/DragAndDrop/DragAndDrop'
import DownloadIcon from '../../../../assets/images/icons/downloadicon.png'
import folder from '../../../../assets/images/icons/folder.png'
import crossButton from '../../../../assets/images/icons/crossbutton.png'

const ImportJobsModal = (props) => {
    const { showModal, handleModalClose, organization_id, setShowModal, currentUser } = props
    const [showSuccessModal, setShowSuccessModal] = useState(false)
    const [formErrorSubmitting, setFormErrorSubmitting] = useState(false)
    const [jobsFile, setJobsFile] = useState('')
    const [companynName, setCompanyName] = useState('')
    const [mentionEMail, seCompanyEmail] = useState('')

    const handleSubmitForm = async (event) => {
        event.preventDefault()
        const url = 'jobs/send_import_jobs'
        var CSRF_Token = document.querySelector('meta[name="csrf-token"]')
            .content

        const headers = {
            'content-type': 'application/json',
            'X-CSRF-Token': CSRF_Token,
        }

        const formData = new FormData()

        formData.append('jobs[notificationemails]', mentionEMail)
        formData.append('jobs[company_name]', companynName)
        formData.append( 'jobs[job_file]',jobsFile)
        formData.append( 'jobs[organization_id]',organization_id)
        // formData.append('logo', companyLogo)

        if (!companynName && !jobsFile) {
            setFormErrorSubmitting(
                'Please upload csv to import job'
            )
            return
        }
        else {
            axios.post(url, formData, { headers })
        }

        handleModalClose()
        setShowSuccessModal(true)
        setFormErrorSubmitting(false)
        setJobsFile()
    }

    const handleCsvFiles = (files) => {
        setJobsFile(files[0])
    }
    return (
        <>
        <Modal size='xl'  show={showModal} onHide={handleModalClose} animation={false}>

            {formErrorSubmitting && (
                    <Alert
                        variant="danger"
                        onClose={() => setFormErrorSubmitting(false)}
                        dismissible
                    >
                        {formErrorSubmitting}
                    </Alert>
                    )}
            <Modal.Body className="import-jobs-modal" >
                <button style={{background:'none', border:'none'}} className='crossbutton' onClick={()=> setShowModal(false)}> <img  src={crossButton}  style={{height: '35px'}} /> </button>
                <div className='import-jobs-modal__model-body'>
                <Row>
                    <Col md={2}>
                        <span className='bulk-import-title'>
                            Bulk Job Import
                        </span>
                    </Col>

                    <Col md={3}>
                        <a href='../bulk_job_import.csv' className="bulk-sample-format-modal">
                            <span>
                                <img src={DownloadIcon} style={{height: '17px', margin: '-1px 12px 4px 2px'}}/>
                                Download Sample Format
                            </span>
                        </a>
                    </Col>

                    <Col md={4}>
                        <span className="import-jobs-modal__span">
                            Ensure your CSV file has the proper formatting by checking out our sample spreadsheet
                        </span>
                    </Col>
                </Row>

                <form>
                    <Row md={8}>
                        <Col className='import-job-company-section'>
                            <label  className="file-upload__label">
                                <span
                                    className="import-jobs-modal__span"
                                >
                                    Company Name
                                </span>
                            </label>

                            <input
                                required
                                className="placeholderText"
                                type="text"
                                id={nanoid()}
                                onChange={(event) =>
                                    setCompanyName(event.target.value)
                                }
                            />
                        </Col>
                    </Row>

                    <Row>
                        <Container className='file-upload'>
                            <DragAndDrop
                                handleFiles={handleCsvFiles}
                                pageName='jobfile'
                            />
                        </Container>
                    </Row>
                    <Row className='file-uploaded'>
                        {
                        jobsFile &&
                            <Col>
                                <img src={folder} style={{height: '31px', marginRight: '15px'}}/>
                                <label className='file-upload__title'>File Uploaded:</label>
                                &nbsp;
                                <span className='file-uploaded__name'>
                                    <span className='import-jobs-modal__span'>{jobsFile.name}</span>
                                </span>
                            </Col>
                        }

                    </Row>

                    <Row>
                        <Col>
                        <label  className="file-upload__label">
                            <span
                                className="import-jobs-modal__span"
                            >
                                Which emails should the notifications for this job be sent to?
                            </span>
                        </label>
                        <input
                                required
                                className="placeholderText__mail"
                                type="text"
                                id={nanoid()}
                                onChange={(event) =>
                                    seCompanyEmail(event.target.value)
                                }
                            />
                        </Col>
                    </Row>

                    <button
                        onClick={handleSubmitForm}
                        className="submit-import-jobs-modal"
                    >
                        <span>Submit</span>
                    </button>
                </form>
                </div>
            </Modal.Body>
        </Modal>
        <SuccessModal
                showModal={showSuccessModal}
                handleModalClose={() => setShowSuccessModal(false)}
            />

        </>
    )
}

export default ImportJobsModal
