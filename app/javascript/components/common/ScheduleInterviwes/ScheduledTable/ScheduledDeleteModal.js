import React from 'react';
import { Modal} from 'react-bootstrap'
import styles from './styles/ScheduledTable.module.scss'

function ScheduledDeleteModal({ index, feedbackCancelModal, setFeedbackCancelModal, handlefeedbackCancel, setDeleteModal, feedbackId, setShowCancelModal }) {
  return(
          <Modal
            className="scheduleModal"
            show={index === feedbackCancelModal}
            onHide={() => setFeedbackCancelModal(false)}
            aria-labelledby="contained-modal-title-vcenter"
            backdropClassName={styles.modalBackdrop}
            size="xl"
            style={{zIndex: '9999'}}
            centered
            >  
              <Modal.Body className={styles.modalBody}>
                <div className={styles.areYouSureText}>Are you sure you want to delete feedback </div>
                <div
                  onClick={() => setFeedbackCancelModal(false)}
                  className={styles.scheduleCancelButton}
                >
                  <i className={styles.cancelIcon} data-feather="x" />
                </div>
                <button
                className={styles.yesCancelBtn}
                onClick={() => handlefeedbackCancel(feedbackId)}
                >
                  Yes, I want to delete
                </button> 
                <button
                    className={styles.noScheduleBtn}
                    onClick={() => {
                      setFeedbackCancelModal(null)
                        setDeleteModal(false)
                    }}
                >
                    No, I do not want to delete
              </button> 
              </Modal.Body>
          </Modal>
        )
}

export default ScheduledDeleteModal;
