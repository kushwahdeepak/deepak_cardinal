import React, {useState} from 'react'
import Modal from 'react-bootstrap/Modal'
import Button from 'react-bootstrap/Button'
import { makeRequest } from '../../common/RequestAssist/RequestAssist'
import style from './styles/JobDeleteConfirmationModal.module.scss'


function JobExtendConfirmationModal({setJobExtend, jobExtend, job, noDayExtend}) {
  const handleNo = () => setJobExtend(false);
  async function handleUpdateJob(value) {
    const url = `/jobs/${job.id}/extend_job`
    const formData = new FormData()
    formData.append('no_of_days', value)
    
    try{
      await makeRequest(url, 'put', formData, {
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
  }

  return (
    <Modal show={jobExtend} onHide={handleNo} style={{marginTop: '140px'}}>
      <Modal.Header closeButton className={`${style.modalHeaderJobDeleteConfirm}`}>
        <Modal.Title className={`${style.modalTitleJobDeleteConfirm}`}>Confirmation</Modal.Title>
      </Modal.Header>
      <Modal.Body className={`${style.modalBodyJobDeleteConfirm}`}>Are you sure to extend this job?</Modal.Body>
      <Modal.Footer className={`${style.modalFooterJobDeleteConfirm}`}>
        <Button variant="primary" onClick={() => {handleUpdateJob(noDayExtend)}}>
          Yes
        </Button>
        <Button variant="secondary" onClick={handleNo}>
          No
        </Button>
      </Modal.Footer>
    </Modal>
  );
}

export default JobExtendConfirmationModal