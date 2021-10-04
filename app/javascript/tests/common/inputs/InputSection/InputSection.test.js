import React from 'react';
import InputSection from '../../../../components/common/inputs/InputSection/InputSection';
import renderer from 'react-test-renderer';
import { configure, shallow, mount } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import { findByTestAttr } from '../../../../utils';

configure({adapter: new Adapter()});

const initialShallowRender = (props = {}) => {
	return shallow(<InputSection {...props}/>);
};

const initialMountRender = (props = {}) => {
	return mount(<InputSection {...props}/>);
};


describe('InputSection component',  () => {
	let wrapper;
	let fullWrapper;

	beforeEach(() => {

		const props = {
		};
		wrapper = initialShallowRender(props);
		fullWrapper = initialMountRender(props);
	});

	afterEach(() => {
		fullWrapper.unmount();
	});

	it('should render InputSection component', () => {
		expect(wrapper.exists()).toBe(true);
	});

	it('should match with a snapshot', () => {
		const component = renderer.create(<InputSection />);
		let tree = component.toJSON();
		expect(tree).toMatchSnapshot();
	});

	describe('InputSection component with props', () => {
		let wrapper;
		let fullWrapper;

		beforeEach(() => {

			const props = {
				big: true
			};
			wrapper = initialShallowRender(props);
			fullWrapper = initialMountRender(props);
		});

		afterEach(() => {
			fullWrapper.unmount();
		});

		it('should render full container', function () {
			const component = findByTestAttr(wrapper, 'full-container');
			expect(component.length).toBe(1);
		});
	});
	describe('InputSection component without props', () => {

	});
});
