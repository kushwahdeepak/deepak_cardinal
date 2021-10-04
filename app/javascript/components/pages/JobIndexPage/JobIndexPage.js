import React, { useEffect, useState } from "react";
import feather from "feather-icons";
import Card from "react-bootstrap/Card";
import Container from "react-bootstrap/Container";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
import Badge from "react-bootstrap/Badge";
import Button from "react-bootstrap/Button";
import Alert from "react-bootstrap/Alert";
import Form from "react-bootstrap/Form";
import axios from "axios";

import SearchBar from "./JobSearchBar"
import FilterJob from "../../FilterJob";
import Paginator from "../../common/Paginator/Paginator";
import "./styles/JobIndexPage.scss";

const RESULTS_PER_PAGE = 25;

function buildJobItem(job, setErrorDeletingJob, jobBaseUrl) {

  const handleDelete = () => {
    const token = document.querySelector('meta[name="csrf-token"]').content;
    const formData = new FormData();
    formData.append("authenticity_token", token);

    fetch(`/jobs/${job.id}`, {
      method: "DELETE",
      body: formData,
    }).then((response) =>
      response
        .json()
        .then((json) => {
          window.location.replace(`/jobs`);
        })
        .catch((err) => setErrorDeletingJob(err.message))
    );
  };

  const displaySkills = job.skills.split(",").map((skill, index) => {
    if (skill) {
      return (
        <Badge
          pill
          key={index}
          variant="secondary"
          className="m-1 d-inline-block text-truncate"
          style={{ paddingTop: ".5em", whiteSpace: "break-spaces" }}
        >
          {skill}
        </Badge>
      );
    } else {
      return "no skills information available";
    }
  });

  return (
    <React.Fragment key={job.id}>
      <Row
        key={job.id}
        className="d-flex justify-content-between align-items-center mx-3 my-3"
      >
        <Col className="m-2">
          <Row>
            <Col className="pl-0">
              <a href={`/${jobBaseUrl}/${job.id}`} className="pr-1">
                {job.name}
              </a>{" "}
              {" - "}
              {job.portalcompanyname
                ? job.portalcompanyname
                : "no company information available"}
            </Col>
          </Row>
          <Row>
            <Col className="pl-0">
              Salary Range:{" "}
              {job.compensation || "no compensation information available"}
            </Col>
          </Row>
          <Row>
            <Col xs="auto" className="px-0">
              Skills:
            </Col>
            <Col xs={10}>
              <Row>{displaySkills}</Row>
            </Col>
          </Row>
        </Col>
        <Col xs="auto" className="m-2">
          <Row>
            <Button
              variant="link"
              href={`/jobs/${job.id}/edit`}
              className="text-secondary"
            >
              <i data-feather="edit" />
            </Button>
            <Button variant="link" onClick={handleDelete}>
              <i data-feather="trash" className="text-danger" />
            </Button>
          </Row>
        </Col>
      </Row>
      <hr />
    </React.Fragment>
  );
}

function JobIndexPage({ jobs, jobSearch, currentUser, isCandidate, jobsTotalCount }) {
  const jobBaseUrl = currentUser ? 'jobs' : 'jobs'

  const [activePage, setActivePage] = useState(0);
  const [errorDeletingJob, setErrorDeletingJob] = useState(null);

  const [jobLocation, setJobLocation] = useState('');
  const [jobTitle, setJobTitle] = useState("");
  const [experienceYears, setExperienceYears] = useState();

  const [filterStack, setFilterStack] = useState({
    skills: jobSearch.skills ? jobSearch.skills.split(",") : [],
    companyNames: jobSearch.company_names ? jobSearch.company_names.split(",") : [],
    keywords: jobSearch.keyword ? jobSearch.keyword.split(",") : [],
    locations: jobSearch.location ? jobSearch.location.split(','):[]
  });



  const remainderResults = jobsTotalCount % RESULTS_PER_PAGE;
  const pageCount =
    Math.floor(jobsTotalCount / RESULTS_PER_PAGE) + (remainderResults > 0 ? 1 : 0);

  const resultsOnPage = (pageIndex) => {
    if (remainderResults > 0 && pageIndex === pageCount - 1) {
      return remainderResults;
    }
    return RESULTS_PER_PAGE;
  };

  const firstVisibleJob = activePage * RESULTS_PER_PAGE;
  const lastVisibleJob = activePage * RESULTS_PER_PAGE + resultsOnPage(activePage);
  const visibleJobs = jobs.slice(firstVisibleJob, lastVisibleJob);

  useEffect(() => {
    feather.replace();
  });
  const handleFilter = () => {
    const searchData = {
      title: jobTitle,
      locations: filterStack.locations.toString(),
      experience_years: experienceYears,
      pref_skills: filterStack.skills.toString(),
      skills: filterStack.skills.toString(),
      company_names: filterStack.companyNames.toString(),

    };
    const token = document.querySelector('meta[name="csrf-token"]').content;
    let payload = {
      authenticity_token: token,
    }
    if (currentUser) {
      payload = {
        ...payload,
        ...searchData,
      }
    }
    else {
      payload['job_search'] = {
        ...searchData,
      }
    }
    axios
      .post(`/job_searches.json`, payload)
      .then((res) => {
        window.location.replace(`/${currentUser ? 'job_searches/' : 'job_searches/'}${res.data.id}`);
      })
      .catch((e) => {
        setErrorDeletingJob(e.message);
      });
  };

  const goToNextPage = (page) => {
    if (page === activePage) return;
    if (jobSearch) {
      window.location.replace(`/job_searches/${jobSearch.id}?page=${page}`);
    }
    else {
      window.location.replace(`/${currentUser ? 'jobs' : 'jobs'}?page=${page}`);
    }
  };

  const handleNextPage = (pageIndex) => {
    goToNextPage(pageIndex + 1)
  }

  return (
    <Container fluid className="fluid"  >

      {currentUser ?
        <Container className="p-1 container" fluid>
          {/* Filters column */}
          <Col className={"filter order-2 order-md-1"}>
            <FilterJob
              filterStack={filterStack}
              setStackFilter={setFilterStack}
              handleSearch={handleFilter}
              jobSearch={jobSearch}
              experienceYears={experienceYears}
              setExperienceYears={setExperienceYears}
            />
          </Col>
        </Container>
        : ''}
      <Card className="my-5" >
        <Card.Header
          as="div"
          className="header  d-flex justify-content-between"
        >
          <p>Job Search</p>
          <p>
            Displaying {visibleJobs.length} out of {jobsTotalCount} jobs
          </p>
        </Card.Header>
        <Card.Header>

          <label htmlFor="basic-url">Search</label>
          <Form onSubmit={handleFilter} className="formDisplay">
            <SearchBar
              user={currentUser}
              handleFilter={handleFilter}
              jobTitle={jobTitle}
              setJobTitle={setJobTitle}
              jobLocation={jobLocation}
              setJobLocation={setJobLocation}
              jobSearch={jobSearch}

            />
          </Form>
          {errorDeletingJob && (
            <Alert
              variant="danger"
              onClose={() => setErrorDeletingJob(null)}
              dismissible
            >
              {errorDeletingJob}
            </Alert>
          )}
        </Card.Header>
        <Card.Body>
          {visibleJobs.map((job) => buildJobItem(job, setErrorDeletingJob, jobBaseUrl))}

          {pageCount > 1 && (
            <div className="d-flex mt-3 justify-content-center">
              <Paginator
                pageCount={pageCount}
                pageWindowSize={5}
                activePage={jobsTotalCount ? activePage - 1 : activePage}
                setActivePage={jobsTotalCount ? handleNextPage : setActivePage}
              />
            </div>
          )}
        </Card.Body>
        <Card.Footer className="bg-white mx-3">
          {jobSearch && (
            <Card.Link className="text-secondary" href="/jobs">
              Go back to all jobs
            </Card.Link>
          )}
          {!isCandidate && currentUser && (
            <Card.Link className="text-secondary" href="/jobs/new">
              Add new job
            </Card.Link>
          )}
        </Card.Footer>
      </Card>
    </Container>
  );
}

export default JobIndexPage;

JobIndexPage.defaultProps = {
  jobs: [],

};