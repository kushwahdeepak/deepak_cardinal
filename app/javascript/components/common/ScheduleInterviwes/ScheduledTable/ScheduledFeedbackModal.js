import React, {useRef} from 'react';
import style from '../../../pages/EmployerDashboard/Table/styles/Table.module.scss'
import styles from './styles/ScheduledTable.module.scss'
import { Button, Row ,Col, Modal, Alert} from 'react-bootstrap'
import ScheduledDeleteModal from './ScheduledDeleteModal'

function ScheduledFeedbackModal({ isErrorMessage, data, myInterview, feedbackCancelModal, useOnClickOutside, setFeedbackCancelModal, handleUpdateModalFeedback, setFeedbackId, handleModalFeedback, handlefeedbackCancel, setDeleteModal, feedbackId, feedbackModal, setFeedbackModal, setShowCancelModal, setModal, errormessageType, message }) {
  const ref = useRef();
  // useOnClickOutside(ref, () => setFeedbackModal(false));

  return(
         <>
          {feedbackModal &&
            <div ref={ref}>
              <div className={`${styles.feedbackModalDialog}`} style={{zIndex: '9999', overflowX: 'hidden', maxWidth: '500px', overflowY: 'auto'}}>
                <Row className={`${styles.feedbackModalHeader}`}>
                  <h4>FeedBack</h4>
                  <div onClick={()=>{handleModalFeedback()
                    setModal(false)}}>
                    <button className={`${styles.feedbackAddButton}`}>
                      <div style={{color: 'white'}}> + Add Feedback </div>
                    </button>
                    </div>
                    <button type="button" className={`${styles.feedbackCloseButton}`} onClick={() =>{setFeedbackModal(false)}}><span aria-hidden="true"><i className={styles.cancelIcon} data-feather="x" /></span></button>
                  </Row>
              
              {isErrorMessage && <Alert className={`${styles.feedbackAlert}`} variant={errormessageType}>{message}</Alert>}
              <div style={{padding: '2px 30px'}}>
                <div>
                  {data?.data?.length >0 && 
                    <Row className={ style.tableHeadingText + ' d-flex align-items-center mt-3'}>
                      <Col xs={1} className="d-flex align-items-start mt-3">
                          <span style={{ marginLeft: '-26px' }}>Serial Number</span>
                      </Col>
                      <Col className={`${style.jobsPadding}`} className="mt-3" xs={6}>
                          <span>Feedback</span>
                      </Col>
                      {myInterview ?
                       <Col className={`${style.jobsPadding}`} className="mt-3" xs={5}>
                         <span>Action</span>
                      </Col>
                      : ''}
                    </Row>
                  }
                  {data?.data?.length > 0 ? data?.data?.map((data, index) => (
                    <Row className={`${styles.tableHeadingText} ${styles.tableRow} d-flex align-items-center`} style={{paddingBottom : myInterview === false ? '30px' :''}} key={index}>
                      <Col md={1} className={`${styles.serialNumber}`}> 
                          {index + 1}
                      </Col>
                      <Col md={6} className={`${styles.feedBackText}`}>
                          {data?.feedback}
                      </Col>
                      {myInterview ?
                        <Col className={`${styles.action}`} xs={5}>
                            <Button className={`${styles.actionButton}`} onClick={()=>{handleUpdateModalFeedback(data?.feedback)
                              setFeedbackId(data.id) }}> Update </Button>
                          <Button className={`${styles.actionButton}`}   onClick={() => {
                              setFeedbackCancelModal(index)
                              setFeedbackId(data.id)
                            }}>Delete</Button>
                        </Col>
                      : ''}  
                      <ScheduledDeleteModal
                      index={index}
                      feedbackCancelModal={feedbackCancelModal}
                      setFeedbackCancelModal={setFeedbackCancelModal}
                      handlefeedbackCancel={handlefeedbackCancel}
                      setDeleteModal={setDeleteModal}
                      feedbackId={feedbackId}
                      setShowCancelModal={setShowCancelModal}
                      />  
                    </Row> 
                    )) :
                      <div className={`${styles.feedbackNotAvaialble}`}>Feedback is not available!</div>
                  }
                </div>
              </div>
            </div>
            </div> 
          } 
        </>
  )
}

export default ScheduledFeedbackModal;