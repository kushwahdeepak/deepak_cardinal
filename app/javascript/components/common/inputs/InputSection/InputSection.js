import React from "react";
import { Col, Row, Container } from "react-bootstrap";

function InputSection({ label, children, big }) {
  if (big) {
    return (
      <Container style={{ paddingTop: "0.5rem", paddingBottom: "0.5rem" }} data-test="full-container">
        <Row>
          <Col sm={4}>
            <div className="med-light-label align-content-end text-xs-left text-sm-right">
              {label}
            </div>
          </Col>
          <Col sm={8} className="justify-content-start">
            <div className="p-1">{children}</div>
          </Col>
        </Row>
      </Container>
    );
  } else {
    return (
      <>
        <div className="med-light-label">{label}</div>
        <div className="p-2">{children}</div>
      </>
    );
  }
}

export default InputSection;
