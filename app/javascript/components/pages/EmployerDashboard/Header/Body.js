import React,{useState, useContext} from 'react'
import {Modal} from 'react-bootstrap'
import Step1 from './Step1'
import Step2 from './Step2'
import Step3 from './Step3'
import Step4 from './Step4'
import './styles/Jobs.scss'
import {CustomModalContext} from '../../../../context/CustomModalContext'



function Body({currentUser, job, isTrueModal, handleEmailSequenceModalOpen, setIsTrueModal, setOpenEmailSequenceModal, openEmailSequenceModal}) {
  const totalCreateForms = 4
  const modalBar = useContext(CustomModalContext)
  const formState = modalBar.formState
  const activeCreateForm = modalBar.activeCreateForm
  const [saveJob, setSaveJob] = useState([]);
  const prevButton = () => (
    <span
      style={activeCreateForm !== 0 ? {display: 'block'} : {display: 'none'}}
    >
      <button
        type="button"
        id={
          activeCreateForm === 1
            ? 'btn-prev-0'
            : activeCreateForm === 2
            ? 'btn-prev-1'
            : activeCreateForm === 3
            ? 'btn-prev-2'
            : 'btn-prev-0'
        }
        className="btn btn-circle btn-xl"
      >
      </button>
    </span>
  )

  const nextButton = () => (
    <span
      style={activeCreateForm + 1 < totalCreateForms ? {display: 'block'} : {display: 'none'}}
    >
      <button
        type="button"
        id={
          activeCreateForm === 0
            ? 'btn-next-1'
            : activeCreateForm === 1
            ? 'btn-next-2'
            : activeCreateForm === 2
            ? 'btn-next-3'
            : 'btn-next-1'
        }
        className="btn btn-circle btn-xl"
        disabled={!formState}
      >
      </button>
    </span>
  )

  const currentModalScreen = () => {
    switch (activeCreateForm) {
      case 0:
        return <Step1 currentUser={currentUser} job={job} isTrueModal={isTrueModal}/>
      case 1:
        return <Step2 job={job} />
      case 2:
        return <Step3 job={job} />
      case 3:
        return <Step4 isTrueModal={isTrueModal} saveJob={saveJob} setSaveJob={setSaveJob} handleEmailSequenceModalOpen={handleEmailSequenceModalOpen} setIsTrueModal={setIsTrueModal} openEmailSequenceModal={openEmailSequenceModal} setOpenEmailSequenceModal={setOpenEmailSequenceModal} />
      default:
        return null
    }
  }

  return (
    <Modal.Body>
        <div className="row">
        <div className="col-1"></div>
          <div className="col-10">{currentModalScreen()}</div>
        </div>
    </Modal.Body>
  )
}

export default Body
