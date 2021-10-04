import React, { useState } from "react";
import Form from "react-bootstrap/Form";
import Modal from "react-bootstrap/Modal";
import Button from "react-bootstrap/Button";
import Card from "react-bootstrap/Card";
import Alert from "react-bootstrap/Alert";
import Autocomplete from "react-autocomplete";
import axios from "axios";

function SubmitCandidateToJob({
  candidate,
  jobs,
  submissions,
  currentUser,
  show,
  onHide,
  setCandidateSubmited,
}) {
  const [selectJob, setSelectJob] = useState("");
  const [errorSubmitting, setErrorSubmitting] = useState(null);

  let jobItems = jobs && jobs.map((j) => {
    return {
      id: j[0],
      label: j[1],
      company: j[2],
      searchString: `${j[1]}(${j[2]}, jobid=${j[0]})`,
    };
  });

  const matchStateToTerm = (state, term) => {
    return state.searchString.toLowerCase().indexOf(term.toLowerCase()) !== -1;
  };

  const handleSubmit = () => {
    const job = jobItems.find((j) => j.searchString === selectJob);
    if (job == null || selectJob === "") return;

    var token = document.querySelector('meta[name="csrf-token"]').content;
    axios
      .post(`/submissions`, {
        authenticity_token: token,
        job_id: job.id,
        user_id: currentUser.id,
        person_id: candidate.id,
        commit: "Submit",
      })
      .then((res) => {
        onHide();
        setCandidateSubmited(true);
        setSelectJob("");
        setErrorSubmitting(null);
      })
      .catch((err) => {
        setErrorSubmitting(err.message);
      });
  };

  const hideModal = () => {
    setSelectJob("");
    setErrorSubmitting(null);
    onHide();
  };

  return (
    <Modal
      onHide={hideModal}
      show={show}
      size="lg"
      aria-labelledby="contained-modal-title-vcenter"
      scrollable
    >
      <Modal.Header closeButton>
        <Modal.Title id="contained-modal-title-vcenter" className="mx-auto">
          Submit candidate to a job
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Card className="my-3">
          <Card.Body>
            {errorSubmitting && (
              <Alert
                variant="danger"
                onClose={() => setErrorSubmitting(null)}
                dismissible
              >
                {errorSubmitting}
              </Alert>
            )}
            <Form>
              <Form.Group>
                <Form.Label>Job</Form.Label>
                <Autocomplete
                  className="w-100"
                  shouldItemRender={matchStateToTerm}
                  getItemValue={(item) => item.searchString}
                  items={jobItems}
                  renderItem={(item, isHighlighted) => (
                    <div
                      key={item.id}
                      style={{
                        background: isHighlighted ? "lightgray" : "white",
                      }}
                    >
                      {item.searchString}
                    </div>
                  )}
                  renderInput={(props) => {
                    return <input {...props} style={{ width: "100%" }} />;
                  }}
                  wrapperStyle={{ display: "block" }}
                  value={selectJob}
                  onChange={(e, v) => setSelectJob(v)}
                  onSelect={(val) => setSelectJob(val)}
                />
              </Form.Group>
            </Form>
            <hr />
            <Card.Title>Existing Submissions</Card.Title>

            {submissions && submissions.map((s, index) => (
              <Card.Body key={index}> {s} </Card.Body>
            ))}
          </Card.Body>
        </Card>
      </Modal.Body>
      <Modal.Footer>
        <Button variant="light" onClick={hideModal}>
          Close
        </Button>
        <Button variant="primary" onClick={handleSubmit}>
          Submit
        </Button>
      </Modal.Footer>
    </Modal>
  );
}

export default SubmitCandidateToJob;
