import React, {useState} from 'react'
import Modal from 'react-bootstrap/Modal'
import Button from 'react-bootstrap/Button'
import styles from './styles/ScheduleInterviewDetails.module.scss'
import './styles/RenderInterviewScheduleDetails.css'
import Form from 'react-bootstrap/Form'
import CalendarIcon from '../../../../assets/images/icons/calendar-icon.svg'
import TimeIcon from '../../../../assets/images/icons/clock-icon.svg'
import ResumeIcon from '../../../../assets/images/icons/resume-icon.svg'
import ResumeTabIcon from '../../../../assets/images/resume_icon-dash.png'
import InterviewIcon from '../../../../assets/images/intreview-tab.png'
import PencilIcon from '../../../../assets/images/icons/pencil-icon-v2.svg'
import { interviewStageTime } from '../Utils'
function RenderInterviewScheduleDetails(props) {
  const Props = props.interviewModal.data.interview_schedule
  
  return(
    <>
        <Modal
            show={props.show}
            onhide={props.hideModal}
            size="lg"
            aria-labelledby="contained-modal-title-vcenter"
            centered
            className="render box--shadow"
        >
            <Modal.Header>
                <Modal.Title id="contained-modal-title-vcenter">
                <p className="mt-2 interview">Your interview has been scheduled!</p>
                <span className="mt-2 interview-text">A confirmation email will be sent soon.</span>
                </Modal.Title>
            </Modal.Header>
            <Modal.Body>
                <div className="row">
                    <div className="col-lg-6">
                        <span className="dot">
                            <img src={CalendarIcon} style={{margin: "16px"}}/>
                            <span className="date"> Date: </span>
                            <span className="date-value"> {Props?.interview_date} </span>
                        </span>                        
                    </div> 
                 </div> 
                {props?.interviewModal?.data["interview_schedule_list"].map((row)=>{
                    return (
                        <>
                            <div className="row" style={{marginBottom:"10px"}}>
                                <div className="col-lg-6">
                                    <div className="mt-1">
                                        <div className="dot" style={{top:"-2px"}}></div> 
                                        <img className="dot-img" src={TimeIcon} />
                                    </div>
                                    <div className="mt-2">
                                        <span className="date date-left"> Time: </span>
                                        <span className="date-value date-left">{interviewStageTime(row?.interview_time ? row?.interview_time : '')}</span>
                                    </div>
                                </div>
                                <div className="col-lg-6">
                                    <div className="dot" style={{top:"-2px"}}> 
                                        <span className="date"> Stage: </span> <img className="event-marg" src={ResumeIcon}/>
                                        <span className="date-value" >
                                            {row?.interview_type == 'recruitor_screen' ? 'Recruiter screen' : row?.interview_type }
                                        </span>
                                    </div> 
                                </div>
                            </div>  
                            
                     </>
                    )})
                }
                <div className="row">
                    <div className="col-lg-6">
                    {Props?.description != '' &&
                    <div>
                        <div className="dot event-desc">
                            <span className="date"> Event Description: </span> <img className="event-marg" src={ResumeIcon}/>
                            <span className="event-value" >
                                {Props?.description}
                            </span>
                        </div>
                   </div>
                   }
                    </div>    
                    <div className="col-lg-6">
                        <div className={styles.selectorContainer} >
                            <div className={styles.emailCheackbox}>
                                <Form.Check
                                    className="checkbox"
                                    type="checkbox"
                                    value="email"
                                    name="email"
                                    checked={true}
                                    style={{top:"25px"}}
                                />
                                <span className="textCheckbox" style={{top:"28px" }}>
                                    Send Google calendar invite to added interviewers 
                                </span>
                            </div>        
                        </div>
                        <div className={styles.selectorContainer}>
                            <div className={styles.emailCheackbox}>
                                <Form.Check
                                    className="checkbox"
                                    type="checkbox"
                                    value="email"
                                    name="email"
                                    checked={true}
                                    style={{top:"50px"}}
                                />
                                <span className="textCheckbox" style={{top:"53px" }}>
                                    Send email to candidate
                                </span>
                            </div>        
                        </div>
                        <div className={styles.selectorContainer}>
                            <div className={styles.emailCheackbox}>
                                <Form.Check
                                    className="checkbox"
                                    type="checkbox"
                                    value="email"
                                    name="email"
                                    checked={true}
                                    style={{top:"75px"}}
                                />
                                <span className="textCheckbox" style={{top:"78px"}}>
                                    Send Google calendar invite to the candidate
                                </span>
                            </div>        
                        </div>     
                    </div>
                </div>         
            </Modal.Body>
            <Modal.Footer>
                <button className="cross-button mt-3" onClick={props.hideModal} ><span className="cross">x</span></button>
            </Modal.Footer>
        </Modal>
    </>
  )
}
export default RenderInterviewScheduleDetails
