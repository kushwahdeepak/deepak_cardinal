import React from "react";
import Container from "react-bootstrap/Container";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
import Card from "react-bootstrap/Card";
import moment from "moment";

function Feedbacks({ transitions }) {
  return (
    <Container>
      <Row className="justify-content-between">
        <Col xs="auto">Feedbacks</Col>
      </Row>
      {[...transitions].reverse().map((transition) => (
        <Card className="mb-2" key={transition.id}>
          <Card.Body>
            <Row>
              <Col>
                <Row className="mb-2">
                  <Col>Stage: {transition.stage.toUpperCase()}</Col>
                  <Col xs={4}>
                    {moment(transition.updated_at).format("DD MMM, YYYY  HH:mm")}
                  </Col>
                </Row>
                <Row>
                  <Col>{transition.feedback ? transition.feedback : 'No feedback'}</Col>
                </Row>
              </Col>
            </Row>
          </Card.Body>
        </Card>
      ))}
    </Container>
  );
}

export default Feedbacks;
