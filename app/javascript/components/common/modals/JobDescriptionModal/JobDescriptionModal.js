import React from "react"
import Modal from 'react-bootstrap/Modal';
import Container from 'react-bootstrap/Container';
import Button from 'react-bootstrap/Button';
import isEmpty from 'lodash.isempty';

function JobDescriptionModal({onHide, show, job}) {

  const hasLocationOrCompany = !isEmpty(job.location) || !isEmpty(job.company)
  if(!job) {
    return (<h2>No suitable job</h2>)
  }

  return (
    <Modal
      onHide={onHide}
      show={show}
      size="lg"
      aria-labelledby="contained-modal-title-vcenter"
      centered
      scrollable
    >
      <Modal.Header closeButton>
        <Modal.Title id="contained-modal-title-vcenter">
          {job.name}
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Container>
          <p>
            {!isEmpty(job.location) ? job.location + ", " : ""} {job.company} {(hasLocationOrCompany ? " - up to " : "") + job.compensation}
          </p>

          <p>
            {job.description}
          </p>

          <hr/>

          <h5>General requirements</h5>
          <ul>
            {job.genReqs && job.genReqs.length && job.genReqs.map(req => (
              <li style={{display: "list-item", listStyle: "disc"}} key={req}>{req}</li>
            ))}
          </ul>

          <h5>Required skills</h5>
          <ul>
            {job.skills && job.skills.length && job.skills.map(skill => (
              <li style={{display: "list-item", listStyle: "disc"}} key={skill}>{skill}</li>
            ))}
          </ul>

          <h5>Preferred skills</h5>
          <ul>
            {job.prefSkills && job.prefSkills.length && job.prefSkills.map(prefSkill => (
              <li style={{display: "list-item", listStyle: "disc"}} key={prefSkill}>{prefSkill}</li>
            ))}
          </ul>

          <h5>Benefits</h5>
          <ul>
            {job.benefits && job.benefits.length && job.benefits.map(benefit => (
              <li style={{display: "list-item", listStyle: "disc"}} key={benefit}>{benefit}</li>
            ))}
          </ul>
        </Container>
      </Modal.Body>
      <Modal.Footer>
        <Button href={"/jobs/" + job.id + "/edit"} variant="secondary">Edit post</Button>
        <Button type="button" onClick={onHide}>Close</Button>
      </Modal.Footer>
    </Modal>
  );
}

export default JobDescriptionModal
