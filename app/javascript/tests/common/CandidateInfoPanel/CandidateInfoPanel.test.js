import React from 'react';
import CandidateInfoPanel from '../../../components/common/CandidateInfoPanel/CandidateInfoPanel';
import renderer from 'react-test-renderer';
import { configure, shallow, mount } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import { findByTestAttr } from '../../../utils';

configure({adapter: new Adapter()});

const initialShallowRender = (props = {}) => {
	return shallow(<CandidateInfoPanel {...props}/>);
};

const initialMountRender = (props = {}) => {
	return mount(<CandidateInfoPanel {...props}/>);
};

const initialProps = {
};

describe('CandidateInfoPanel component',  () => {
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

	it('should render CandidateInfoPanel component', () => {
		expect(wrapper.exists()).toBe(true);
	});

	it('should match with a snapshot', () => {
		const component = renderer.create(<CandidateInfoPanel {...initialProps} />);
		let tree = component.toJSON();
		expect(tree).toMatchSnapshot();
	});

	describe('CandidateInfoPanel component with props', () => {

	});
	describe('CandidateInfoPanel component without props', () => {

	});

});
