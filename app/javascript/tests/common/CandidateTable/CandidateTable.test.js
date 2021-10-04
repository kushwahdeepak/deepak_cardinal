import React from 'react';
import CandidateTable from '../../../components/common/CandidateTable/CandidateTable';
import renderer from 'react-test-renderer';
import { configure, shallow, mount } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import { findByTestAttr } from '../../../utils';

configure({adapter: new Adapter()});

const initialShallowRender = (props = {}) => {
	return shallow(<CandidateTable {...props}/>);
};

const initialMountRender = (props = {}) => {
	return mount(<CandidateTable {...props}/>);
};

const initialProps = {
	candidates: []
};

describe('CandidateTable component',  () => {
	let wrapper;
	let fullWrapper;

	beforeEach(() => {

		const props = {
			...initialProps
		};

		wrapper = initialShallowRender(props);
		fullWrapper = initialMountRender(props);
	});

	afterEach(() => {
		fullWrapper && fullWrapper.unmount();
	});

	it('should render CandidateTable component', () => {
		expect(wrapper.exists()).toBe(true);
	});

	it('should match with a snapshot', () => {
		const component = renderer.create(<CandidateTable {...initialProps} />);
		let tree = component.toJSON();
		expect(tree).toMatchSnapshot();
	});

	describe('CandidateTable component with props', () => {

	});
	describe('CandidateTable component without props', () => {

	});

});
