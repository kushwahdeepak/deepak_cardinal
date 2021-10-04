import React, { useState } from 'react'
import { Button, ButtonGroup, Col, Row, Alert } from 'react-bootstrap'
import Tooltip from 'react-bootstrap/Tooltip'
import OverlayTrigger from 'react-bootstrap/OverlayTrigger'

import styles from './styles/BulkCandiadateUpload.module.scss'
import BulkDragDrop from '../BulkDragDrop/BulkDragDrop'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'

const validCSV = [
    'text/plain',
    'text/x-csv',
    'application/vnd.ms-excel',
    'application/csv',
    'application/x-csv',
    'text/csv',
    'text/comma-separated-values',
    'text/x-comma-separated-values',
    'text/tab-separated-values',
]

function BulkCandidateupload({
    id,
    hideHeaderText,
    hideUploadResume = false,
    isCustomFunction = false,
    handleCustomSubmit = () => {},
}) {
    const [activeButton, setActiveButton] = useState('spreadsheet')
    const [bulkResumes, setBulkResumes] = useState([])
    const [bulkSpreadSheets, setBulkSpreadSheets] = useState([])
    const [validationErrors, setValidationErrors] = useState({})

    const handleResumeFiles = (files) => {
        setBulkResumes([...bulkResumes, ...files])
    }
    const handleSpreadFiles = (files) => {
        setBulkSpreadSheets([...bulkSpreadSheets, ...files])
        setValidationErrors({})
    }

    const handleOnRemoveResumes = (removeIndex) => {
        const newResumes = bulkResumes.filter(
            (_, index) => removeIndex !== index
        )

        setBulkResumes(newResumes)
    }

    const handleOnRemoveSpreadSheet = (removeIndex) => {
        const newResumes = bulkSpreadSheets.filter(
            (_, index) => removeIndex !== index
        )

        setBulkSpreadSheets(newResumes)
        setValidationErrors({})
    }

    const handleSubmitSpreadSheet = async () => {
        setValidationErrors({})
        for (let i = 0; i < bulkSpreadSheets.length; i++) {
            if (!validCSV.includes(bulkSpreadSheets[i].type)) {
                setValidationErrors({
                    ...validationErrors,
                    error: 'Please check the format of file',
                })
                return
            }
        }
        if (Object.values(validationErrors).length === 0) {
            if (isCustomFunction) {
                handleCustomSubmit(bulkSpreadSheets)
            } else {
                const url = '/applicant_batches'

                const formData = new FormData()
                for (let i = 0; i < bulkSpreadSheets.length; i++) {
                    formData.append(
                        'applicant_batch[applicant_files][]',
                        bulkSpreadSheets[i]
                    )
                }
                formData.append('applicant_batch[id]', id)

                const responce = await makeRequest(url, 'post', formData, {
                    contentType: 'application/json',
                    loadingMessage: 'Submitting...',
                    createSuccessMessage: (response) => response.data.message,
                })
            }
        }
    }

    const handleSubmitResume = (bulkResumes) => {}

    return (
        <>
            <div className={styles.wrapper}>
                <div className={styles.header}>Bulk Candidate Upload</div>
                <Row style={{ marginBottom: '20px', width: '100%' }}>
                    <Col style={{ width: 'fit-content', padding: 0,marginBottom: '10px' }}>
                        <ButtonGroup>
                            {!hideUploadResume && (
                                <OverlayTrigger
                                    overlay={
                                        <Tooltip>Not yet functional</Tooltip>
                                    }
                                >
                                    <Button
                                        className={styles.buttonResume}
                                        style={{
                                            background: ` ${
                                                activeButton === 'resumes'
                                                    ? 'rgb(76, 104, 255)'
                                                    : 'rgb(235, 237, 250)'
                                            }`,
                                            color: ` ${
                                                activeButton === 'resumes'
                                                    ? 'rgb(235, 237, 250)'
                                                    : 'rgb(76, 104, 255)'
                                            }`,
                                        }}
                                        onClick={() => {}}
                                    >
                                        Upload resumes
                                    </Button>
                                </OverlayTrigger>
                            )}
                            <Button
                                className={styles.buttonSS}
                                style={{
                                    background: ` ${
                                        activeButton === 'spreadsheet'
                                            ? 'rgb(76, 104, 255)'
                                            : 'rgb(235, 237, 250)'
                                    }`,
                                    color: ` ${
                                        activeButton === 'spreadsheet'
                                            ? 'rgb(235, 237, 250)'
                                            : 'rgb(76, 104, 255)'
                                    }`,
                                }}
                                onClick={() => {
                                    setActiveButton('spreadsheet')
                                }}
                            >
                                Upload CSV spreadsheet
                            </Button>
                        </ButtonGroup>
                        {hideHeaderText ? null : (
                            <span className={styles.textSpan}>
                                These candidates will be uploaded to the
                                pipeline for all those in your organization
                            </span>
                        )}
                    </Col>
                    {Object.values(validationErrors).map((error) => (
                        <Alert
                            key={error}
                            variant="danger"
                            onClose={() => setValidationErrors({})}
                            dismissible
                            className="alert-close"
                        >
                            {error}
                        </Alert>
                    ))}
                </Row>
                {activeButton === 'resumes' ? (
                    <BulkDragDrop
                        title={'resumes'}
                        files={bulkResumes}
                        handleOnRemoveFiles={handleOnRemoveResumes}
                        handleFiles={handleResumeFiles}
                        handleOnSubmit={handleSubmitResume}
                    />
                ) : (
                    <BulkDragDrop
                        title={'CSV  spreadsheet'}
                        files={bulkSpreadSheets}
                        handleOnRemoveFiles={handleOnRemoveSpreadSheet}
                        handleFiles={handleSpreadFiles}
                        handleOnSubmit={handleSubmitSpreadSheet}
                    />
                )}
            </div>
        </>
    )
}

export default BulkCandidateupload
