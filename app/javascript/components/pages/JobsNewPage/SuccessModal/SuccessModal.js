import React from 'react'
import Modal from 'react-bootstrap/Modal'
import '../styles/JobsNewPage.scss'

const SuccessModal = (props) => {
    const { showModal, handleModalClose } = props

    return (
        <Modal
            className="success-modal"
            show={showModal}
            onHide={handleModalClose}
        >
            <Modal.Body>
                <span className="success-modal__text">
                    Thank you for importing your jobs!
                    <br />
                    Your jobs will be posted within 24 hours pending approval.
                </span>
            </Modal.Body>
        </Modal>
    )
}

export default SuccessModal
