import React, { Component } from 'react';

class Results extends Component {

    render() {

        return (
            <table className="slds-table slds-table--bordered slds-table--cell-buffer">
            <thead>
                <tr className="slds-text-title--caps">
                    <th scope="col">
                        <div className="slds-truncate" title="Label">Label</div>
                    </th>
                    <th scope="col">
                        <div className="slds-truncate" title="Probability">Probability</div>
                    </th>
                </tr>
            </thead>
            <tbody>
                {this.props.results.map((result,index) => 
                      <tr>
                        <th scope="row" data-label="Label">
                            <div className="slds-truncate" title="Label">{result.label}</div>
                         </th>
                        <td data-label="Probability">
                            <div className="slds-truncate" title="Probability">{result.probability}</div>
                        </td>
                    </tr>
                )}
            </tbody>
            </table>
        );

    }

}

export default Results;