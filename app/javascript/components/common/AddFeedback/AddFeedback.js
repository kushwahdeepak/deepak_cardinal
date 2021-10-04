import React, { useState } from "react";
import Modal from "react-bootstrap/Modal";
import Container from "react-bootstrap/Container";
import Button from "react-bootstrap/Button";
import Form from "react-bootstrap/Form";
import axios from "axios";
import Util from "../../../utils/util";

import "./AddFeedback.scss";

function AddFeedback({ show, onHide, submission, isReject, submissionInfo, setFeedbackAdded }) {
  const [feedback, setFeedback] = useState("");

  const addFeedback = (isAdding) => {
    var token = document.querySelector('meta[name="csrf-token"]').content;
    var endpoint = isReject ? 'reject' : 'advance_stage'
    axios
      .put(`/submissions/${submission.id}/${endpoint}`, {
        authenticity_token: token,
        stage: {
          feedback: isAdding ? feedback : ""
        }
      })
      .then((res) => {
        setFeedbackAdded(res.data);
        onHide();
        setFeedback("")
      })
      .catch((err) => console.log(err));
  };
  if (!show) return null;

  const getNextStageInfo = () => {
    if (isReject)
      return "REJECT"
      
    let transitions = submission.stage_transitions.filter((transtion) => transtion.stage.toLowerCase() != 'reject')
    if (transitions.length > 0) {
      let index = Util.STAGES.indexOf(transitions[transitions.length - 1].stage.toLowerCase()) 
      return Util.STAGES[index + 1].toUpperCase() == 'REJECT' ? Util.STAGES[index].toUpperCase() : Util.STAGES[index + 1].toUpperCase()
    }
    return "FIRST_INTERVIEW"
  };

  return (
    <Modal
      onHide={onHide}
      show={show}
      size="lg"
      aria-labelledby="contained-modal-title-vcenter"
      scrollable
    >
      <Modal.Header closeButton>
        <Modal.Title id="contained-modal-title-vcenter" className="mx-auto">
          Add Feedback
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Container>
          <Form>
            <Form.Group controlId="exampleForm.ControlTextarea1">
              <Form.Label style={{textTransform: 'initial'}}>Approving {submissionInfo.email_address.toLowerCase()} to the {getNextStageInfo()} stage. 
                Please enter feedback
              </Form.Label>
              <Form.Control
                as="textarea"
                rows="3"
                value={feedback}
                onChange={(e) => setFeedback(e.target.value)}
              />
            </Form.Group>
          </Form>
        </Container>
      </Modal.Body>
      <Modal.Footer>
        <Button variant="light" onClick={ () => addFeedback(false) }>
          Close
        </Button>
        <Button variant="primary" onClick={ () => addFeedback(true) }>
          Add
        </Button>
      </Modal.Footer>
    </Modal>
  );
}

export default AddFeedback;
