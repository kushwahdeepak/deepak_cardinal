import React, {useState} from 'react'
import Modal from 'react-bootstrap/Modal'
import Button from 'react-bootstrap/Button'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import styles from './styles/JobDeleteConfirmationModal.module.scss';

function JobDeleteConfirmationModal({setJobDelete, jobDelete, job}) {
  const handleNo = () => setJobDelete(false);
  const handleDelete = async () => {
    const formData = new FormData()
    const url = `/jobs/${job.id}`
    try {
      const response = await makeRequest(url, 'delete', formData, {
          contentType: 'multipart/form-data',
          loadingMessage: 'Submitting...',
          createResponseMessage: (response) => {
            return {
              message: response.message ? response.message : ' '
            }
          },
      })
    }catch (e) {
      console.error(e.message)
    }
    setTimeout(() => {
        window.location.href = '/employer_home' 
    }, 1000)
    setJobDelete(false);
  }
  return (
    <>
      <Modal show={jobDelete} onHide={handleNo} style={{marginTop: '140px'}}>
        <Modal.Header closeButton className={`${styles.modalHeaderJobDeleteConfirm}`}>
          <Modal.Title className={`${styles.modalTitleJobDeleteConfirm}`}>Confirmation</Modal.Title>
        </Modal.Header>
        <Modal.Body className={`${styles.modalBodyJobDeleteConfirm}`}>Are you sure to close this job?</Modal.Body>
        <Modal.Footer className={`${styles.modalFooterJobDeleteConfirm}`}>
          <Button variant="primary" onClick={handleDelete}>
            Yes
          </Button>
          <Button variant="secondary" onClick={handleNo}>
            No
          </Button>
        </Modal.Footer>
      </Modal>
    </>
  );
}

export default JobDeleteConfirmationModal;