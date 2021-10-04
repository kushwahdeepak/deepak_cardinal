import React, { useState, useEffect } from 'react'
import { Button, ButtonGroup, Col, Row } from 'react-bootstrap'
import Tooltip from 'react-bootstrap/Tooltip'
import OverlayTrigger from 'react-bootstrap/OverlayTrigger'

import styles from './styles/BulkCandiadateUploadPage.module.scss'
import BulkDragDrop from '../../common/BulkDragDrop/BulkDragDrop'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import BulkCandidateUpload from '../../common/BulkCandidateUpload/BulkCandidateUpload'

function BulkCandidateUploadPage({
    webSocketsUrl,
    organization_id,
}) {
    return (
        <section className="d-flex flex-column align-items-center justify-content-center">
            <div className={styles.container}>
                <BulkCandidateUpload
                    id={organization_id}
                    hideHeaderText={false}
                />
            </div>
        </section>
    )
}

export default BulkCandidateUploadPage
