import React, {useState} from 'react'
import {Button, Container, Modal} from 'react-bootstrap'
import {CustomModalContext} from '../../../../context/CustomModalContext'
import './styles/Jobs.scss'
import axios from 'axios';
import EmailSequence from '../../../common/EmailSequence/EmailSequence.js'

function Step4({isTrueModal, saveJob, setSaveJob, handleEmailSequenceModalOpen, openEmailSequenceModal, setOpenEmailSequenceModal}) {
  const [count, setCount] = useState(0)
  const modalBar = React.useContext(CustomModalContext)
  const handleClick = () => {
    modalBar.setBarState({...modalBar.barState, isOpen: false})
  }
  const {fullJob} = saveJob
  const job = modalBar.jobStore
  const handleSubmitData = async () =>{
    setCount(count + 1)
    var form_data = new FormData()
      for (var key in modalBar.testing) {
        if (modalBar.testing[key] == undefined || modalBar.testing[key] === '') {
          continue
        }
        form_data.append(`job[${key}]`, modalBar.testing[key])
      }
      const CSRF_Token = document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute('content')
          modalBar.setLoaderResponse(true)

      try {
        if (job) {
          const response = await axios.put(`/jobs/${job.id}`, form_data, {
            headers: {
              'content-type': 'multipart/form-data',
              'X-CSRF-Token': CSRF_Token,
            },
          })
        } else {
          const response = await axios.post('/jobs.json', form_data, {
            headers: {
              'content-type': 'multipart/form-data',
              'X-CSRF-Token': CSRF_Token,
            },
          })
          modalBar.setEmailJob(response.data)
          setSaveJob(response.data)
        }
        
        if (!Object.keys(response.data).includes('error')) {
            setSuccess(true)
        } else {
            setSuccess(false)
            setErrorTextCustom(response.data.error)
        }
        modalBar.setLoaderResponse(false)
      } catch (e) {
          modalBar.setLoaderResponse(false)
          modalBar.setErrorMessageCustom(e.message)
          modalBar.setErrorTextCustom('An error occurred: ', e.message)
      }
  }
   const handleEmailModal = () => {
    handleSubmitData()
    if(job){
      handleEmailSequenceModalOpen()
    }else{
      handleEmailSequenceAddModal()
    }
   }
   const handleEmailSequenceAddModal = () => {
      setOpenEmailSequenceModal(true)
    }
  return(
         <>
    <div style={{"textAlign": "center"}}>
      {isTrueModal ? 
        <h3>Your job will be updated Successfully!</h3> :
        <h3>Your job is ready to post!</h3>
      }
      <p>You will receive an email confirmation for your job post shortly after this.</p>
      <div className="btn-container">
      <Button variant="primary"
        type="button"
        onClick={handleSubmitData}
        disabled={count >= 1}
      >
        {!isTrueModal ? "Create Job Post" : "Update Job Post"}
      </Button>
        <Button variant="first" type="button" onClick={handleEmailModal} disabled={count >= 1}>
          Create Email Sequences
        </Button>
      </div>
    </div>
    {openEmailSequenceModal && 
             <Container> 
                <Modal
                    className="custom-modal"
                    show={openEmailSequenceModal}
                    onHide={()=>setOpenEmailSequenceModal(false)}
                    size={'xl'}
                    aria-labelledby="contained-modal-title-vcenter"
                    backdrop="static"
                >
                  <Modal.Header closeButton>
                        <Modal.Title id="contained-modal-title-vcenter">
                            Email Sequence
                        </Modal.Title>
                  </Modal.Header>
                  <Modal.Body>
                    <EmailSequence
                      openEmailSequenceModal={openEmailSequenceModal}
                      setOpenEmailSequenceModal={setOpenEmailSequenceModal}
                      job={modalBar.emailJob}
                    />
                  </Modal.Body>
                </Modal>
              </Container>}
    </>
  )
}
export default Step4;