import React, { useState, useEffect } from "react"
import Button from "react-bootstrap/Button"
import Modal from "react-bootstrap/Modal"
import Alert from "react-bootstrap/Alert"
import Expander from "../../common/Expander/Expander"
import TagInput from "../../common/inputs/TagInput/TagInput"
import MultiBooleanInput from "../../common/inputs/MultiBooleanInput/MultiBooleanInput"
import InputSection from "../../common/inputs/InputSection/InputSection"
import feather from "feather-icons"
import PropTypes from "prop-types"
import { nanoid } from "nanoid"
import isEmpty from "lodash.isempty"
import axios from "axios"

function RefinementPage({ job, setJob, transformJobModel, closeFunc }) {
  const [formState, setFormState] = useState({})
  const [statusUpdatingJob, setStatusUpdatingJob] = useState(null)
  const expanderPadding = "1rem"

  const setInputState = (attr, val) => {
    setFormState((lastFormState) => ({ ...lastFormState, [attr]: val }))
  }

  useEffect(() => {
    feather.replace()
  })

  const handleSubmit = () => {
    const modifiedJob = {
      portalcompanyname: formState.company_names.toString(),
      name: formState.title.toString(),
      gen_reqs: formState.discipline.toString(),
      portalcity: formState.location.toString(),
      skills: formState.skills.toString(),
      pref_skills: formState.prefSkills.toString(),
      description: formState.description.toString(),
      compensation: formState.compensation
        .map((comp) =>
          !isEmpty(comp) && comp.charAt(0) !== "$" ? "$" + comp : comp
        )
        .toString(),
      benefits: formState.benefit.toString(),
      work_time: formState.workingTime.toString(),
    }

    delete modifiedJob.id

    var token = document.querySelector('meta[name="csrf-token"]').content

    axios
      .put(`/jobs/${job.id}.json`, {
        authenticity_token: token,
        ...modifiedJob,
      })
      .then((res) => {
        // window.location.reload()
        setJob(transformJobModel(res.data.job))
        setStatusUpdatingJob({ message: res.data.notice, type: "success" })
      })
      .catch((e) => {
        setStatusUpdatingJob({ message: e.message, type: "danger" })
      })
  }

  return (
    <Modal show={true} onHide={closeFunc} backdrop='static' size='lg'>
      <Modal.Header closeButton>
        <Modal.Title as='h1' className='text-center'>
          Refine Position
        </Modal.Title>
      </Modal.Header>
      <Modal.Body className='p-3'>
        {statusUpdatingJob && (
          <Alert
            variant={statusUpdatingJob.type || "danger"}
            onClose={() => setStatusUpdatingJob(null)}
            dismissible
          >
            {statusUpdatingJob.message}
          </Alert>
        )}
        <Expander expanded label='Job Details' padding={expanderPadding}>
          <InputSection label='Decription' big>
            <TagInput
              setInputState={setInputState}
              initialValues={
                job.description
                  ? [{ id: nanoid(), value: job.description }]
                  : []
              }
              testAttr='description'
            />
          </InputSection>
          <InputSection label='Compensation' big>
            <TagInput
              setInputState={setInputState}
              initialValues={
                job.compensation
                  ? [{ id: nanoid(), value: job.compensation }]
                  : []
              }
              testAttr='compensation'
            />
          </InputSection>
          <InputSection label='Working Time' big>
            <TagInput
              setInputState={setInputState}
              initialValues={
                job.workingTime
                  ? [{ id: nanoid(), value: job.workingTime }]
                  : []
              }
              testAttr='workingTime'
            />
          </InputSection>
          <InputSection label='Benefits' big>
            <TagInput
              setInputState={setInputState}
              initialValues={
                job.benefits
                  ? Array.isArray(job.benefits)
                    ? job.benefits
                        .filter((skill) => skill != "")
                        .map((sk) => {
                          return { id: nanoid(), value: sk }
                        })
                    : []
                  : []
              }
              testAttr='benefit'
            />
          </InputSection>
        </Expander>
        <Expander expanded label='Experience' padding={expanderPadding}>
          <InputSection label='Companies' big>
            <TagInput
              setInputState={setInputState}
              initialValues={
                job.company
                  ? job.company.split(",").map((comp) => {
                      return { id: nanoid(), value: comp }
                    })
                  : []
              }
              testAttr='company_names'
            />
          </InputSection>
          <InputSection label='Title' big>
            <TagInput
              setInputState={setInputState}
              initialValues={
                job.name
                  ? job.name.split(",").map((comp) => {
                      return { id: nanoid(), value: comp }
                    })
                  : []
              }
              testAttr='title'
            />
          </InputSection>
        </Expander>
        <Expander
          expanded
          label='General Requirements'
          padding={expanderPadding}
        >
          <InputSection big>
            <TagInput
              setInputState={setInputState}
              initialValues={
                job.genReqs
                  ? Array.isArray(job.genReqs)
                    ? job.genReqs
                        .filter((req) => req != "")
                        .map((req) => {
                          return { id: nanoid(), value: req }
                        })
                    : []
                  : []
              }
              testAttr='discipline'
            />
          </InputSection>
        </Expander>
        <Expander expanded label='Location' padding={expanderPadding}>
          <InputSection big>
            <TagInput
              setInputState={setInputState}
              initialValues={
                job.location
                  ? job.location.split(",").map((loc) => {
                      return { id: nanoid(), value: loc }
                    })
                  : []
              }
              testAttr='location'
            />
          </InputSection>
        </Expander>
        <Expander expanded label='Skills' padding={expanderPadding}>
          <InputSection big>
            <TagInput
              setInputState={setInputState}
              initialValues={
                job.skills
                  ? Array.isArray(job.skills)
                    ? job.skills
                        .filter((skill) => skill != "")
                        .map((sk) => {
                          return { id: nanoid(), value: sk }
                        })
                    : []
                  : []
              }
              testAttr='skills'
            />
          </InputSection>
        </Expander>
        <Expander expanded label='Prefered Skills' padding={expanderPadding}>
          <InputSection big>
            <TagInput
              setInputState={setInputState}
              initialValues={
                job.prefSkills
                  ? Array.isArray(job.prefSkills)
                    ? job.prefSkills
                        .filter((skill) => skill != "")
                        .map((sk) => {
                          return { id: nanoid(), value: sk }
                        })
                    : []
                  : []
              }
              testAttr='prefSkills'
            />
          </InputSection>
        </Expander>
      </Modal.Body>
      <Modal.Footer>
        <Button variant='secondary' onClick={closeFunc}>
          Close
        </Button>
        <Button variant='primary' onClick={handleSubmit}>
          Save Changes
        </Button>
      </Modal.Footer>
    </Modal>
  )
}

RefinementPage.propTypes = {
  job: PropTypes.object.isRequired,
  closeFunc: PropTypes.func.isRequired,
}

export default RefinementPage
