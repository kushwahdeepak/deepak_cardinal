import React, { useState } from 'react'
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip } from 'recharts'

import P from './shared/P'
import Card from './shared/Card'
import { BlockBody, BlockHeader } from './styles/AdminDashboard.styled'

const AdminDashboard = (props) => {
    const information = props.information
    const data = props.data
    const [formContent, setFormContent] = useState(
        information.map((resource) => ({
            name: resource.name,
            todayCount: resource.today_count,
            totalCount: resource.total_count,
        }))
    )

    return (
        <Card>
            <P size="30px" height="41px">
                Admin Dashboard
            </P>
            <div style={{ marginTop: '50px', display: 'flex' }}>
                {formContent.map((resource, idx) => (
                    <div key={idx} style={{ marginLeft: '50px' }}>
                        <BlockHeader width={200}>
                            <P size="16px" height="27px" color="#3F446E">
                                {resource.name}
                            </P>
                        </BlockHeader>
                        <BlockBody>
                            <P size="10px" height="14px" color="#3F446E">
                                Today
                            </P>
                            <P
                                size="20px"
                                height="27px"
                                color="#3F446E"
                                marginTop="5px"
                            >
                                {resource.todayCount}
                            </P>
                        </BlockBody>
                        <BlockBody>
                            <P size="10px" height="14px" color="#3F446E">
                                Total
                            </P>
                            <P
                                size="20px"
                                height="27px"
                                color="#3F446E"
                                marginTop="5px"
                            >
                                {resource.totalCount}
                            </P>
                        </BlockBody>
                    </div>
                ))}
            </div>
            <div style={{ marginTop: '80px' }}>
                <P
                    color="#1D2447"
                    size="18px"
                    height="25px"
                    marginBottom="20px"
                    center
                >
                    Activity in last 7 days
                </P>
                <div>
                    <LineChart width={1000} height={300} data={data}>
                        <Line
                            type="linear"
                            dataKey="candidates_count"
                            stroke="red"
                            dot={false}
                        />
                        <Line
                            type="linear"
                            dataKey="jobs_count"
                            stroke="blue"
                            dot={false}
                        />
                        <Line
                            type="linear"
                            dataKey="recruiters_count"
                            stroke="green"
                            dot={false}
                        />
                        <Line
                            type="linear"
                            dataKey="organizations_count"
                            stroke="orange"
                            dot={false}
                        />
                        <Tooltip />
                        <CartesianGrid stroke="#eee" strokeDasharray="3 3" />
                        <XAxis dataKey="date" />
                        <YAxis />
                    </LineChart>
                </div>
            </div>
        </Card>
    )
}

export default AdminDashboard
